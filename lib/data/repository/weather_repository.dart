// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:js_interop';

import 'package:weatherapp/data/data_provider/weather_data_provider.dart';
import 'package:weatherapp/models/weather_model.dart';

class WeatherRepository {
  WeatherDataProvider weatherDataProvider;
  WeatherRepository({
    required this.weatherDataProvider,
  });
  Future<WeatherModel> getCurrentWeather() async {
    try {
      String cityName = "New Delhi";

      final weatherData = await weatherDataProvider.getCurrentWeather(cityName);

      final data = jsonDecode(weatherData);
      // print(data);
      if (data["cod"] != 200) {
        throw "An unexpected error occurred";
      }
      //print(data);
      return WeatherModel.fromJson(data);
    } catch (e) {
      //print("error ");
      throw e.toString();
    }
  }
}
