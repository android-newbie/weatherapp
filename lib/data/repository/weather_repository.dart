// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


import 'package:weatherapp/data/data_provider/weather_data_provider.dart';
import 'package:weatherapp/models/weather_model.dart';

class WeatherRepository {
  WeatherDataProvider weatherDataProvider;
  WeatherRepository({
    required this.weatherDataProvider,
  });
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    try {
     // String cityName = "Chennai";

      final weatherData = await weatherDataProvider.getCurrentWeather(cityName);
      // print(weatherData);

      final data = json.decode(weatherData);
      print("data $data");
      if (data["cod"] != "200") {
        throw "An unexpected error occurred";
      }
      // final k = WeatherModel.fromJson(data);
      // print("weather $k");
      return WeatherModel.fromJson(data);
    } catch (e) {
      print("${e.toString()}");
      throw e.toString();
    }
  }
}
