import 'package:http/http.dart' as http;
import 'package:weatherapp/secrets.dart';

class WeatherDataProvider {
  Future<String> getCurrentWeather(String cityName) async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey"));

      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
