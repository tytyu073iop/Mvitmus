import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:vitmus/models/weather.dart';
import 'package:vitmus/config.dart';

class WeatherRepository {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeather(double lat, double lng) async {
    if (AppConfig.weatherApiKey == 'PASTE_YOUR_OPENWEATHERMAP_KEY_HERE') {
      throw Exception('OpenWeatherMap API key not configured. Set it in lib/config.dart');
    }

    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'lat': lat.toString(),
        'lon': lng.toString(),
        'appid': AppConfig.weatherApiKey,
        'units': 'metric',
        'lang': 'en',
      });

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Weather API error: ${response.statusCode}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return Weather(
        temperature: (data['main']['temp'] as num).toDouble(),
        feelsLike: (data['main']['feels_like'] as num).toDouble(),
        description: data['weather'][0]['description'] as String,
        icon: data['weather'][0]['icon'] as String,
        humidity: data['main']['humidity'] as int,
        windSpeed: (data['wind']['speed'] as num).toDouble(),
      );
    } catch (e) {
      debugPrint('Error fetching weather: $e');
      rethrow;
    }
  }
}
