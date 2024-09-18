import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:weatherapp/bloc/weather_bloc.dart';
import 'package:weatherapp/presentation/widgets/additional_info_item.dart';
import 'package:weatherapp/presentation/widgets/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final cityTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<WeatherBloc>().add(WeatherFetched());
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: Colors.black,
          title: const Text('Enter City Name'),
          content: TextFormField(
            controller: cityTextController,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fetch'),
              onPressed: () {
                context.read<WeatherBloc>().add(
                    WeatherFetched(cityName: cityTextController.text.trim()));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  giveDataTime(String dtTxt) {
    // Remove the timezone name if it's present
    if (dtTxt.contains(' India Standard Time')) {
      dtTxt = dtTxt.replaceAll(' India Standard Time', '');
    }

    DateTime time;

    try {
      // Parse the cleaned date string
      time = DateTime.parse(dtTxt);
    } catch (e) {
      print("Invalid date format: $e");
      return Container(); // or handle the error appropriately
    }

// Format the time for display
    String formattedTime = DateFormat.j().format(time);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          _showMyDialog();
        },
      ),
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<WeatherBloc>().add(WeatherFetched());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherFailure) {
            return Center(
              child: Text(state.error),
            );
          }

          if (state is! WeatherSuccess) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = state.weatherModel.list;

          final temp = data[0].main.temp;
          final currentTemp = temp - 273.15;
          final currentSky = data[0].weather[0].main.toString();
          final currentPressure = data[0].main.pressure;
          final currentWindSpeed = data[0].wind.speed;
          final currentHumidity = data[0].main.humidity;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '${state.cityName.toUpperCase()}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${currentTemp.toStringAsFixed(2)} C',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // final hourlyForecast = data.[index + 1];
                        final hourlySky =
                            data[index + 1].weather[0].main.toString();
                        final htemp = data[index + 1].main.temp;
                        final hourlyTemp = htemp - 273.15;
                        String dtTxt = data[index + 1].dtTxt.toString();
                        final time = giveDataTime(dtTxt);

                        // final time =
                        //     DateTime.parse(data[index + 1].dtTxt.timeZoneName);

                        return HourlyForecastItem(
                          time: time,
                          temperature: hourlyTemp.toStringAsPrecision(2),
                          icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
