import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/weathermodel.dart';

class WeatherService {
  static const String _baseUri = 'http://api.weatherapi.com/v1/current.json';
  static const String _apiKey = 'a81031c933384ae299691247251405';

  Future<WeatherModel> getWeather(String location) async {
    final response = await http.get(
      Uri.parse('$_baseUri?key=$_apiKey&q=$location'),
    );
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(" failed to load weather data");
    }
  }
}
