import 'package:flutter_test/flutter_test.dart';
import 'package:vitmus/models/weather.dart';

void main() {
  group('Weather model', () {
    test('supports value equality', () {
      final a = Weather(
        temperature: 20.0,
        feelsLike: 18.0,
        description: 'clear sky',
        icon: '01d',
        humidity: 50,
        windSpeed: 3.5,
      );
      final b = Weather(
        temperature: 20.0,
        feelsLike: 18.0,
        description: 'clear sky',
        icon: '01d',
        humidity: 50,
        windSpeed: 3.5,
      );
      expect(a, equals(b));
    });

    test('different temperature means not equal', () {
      final a = Weather(
        temperature: 20.0,
        feelsLike: 18.0,
        description: 'clear sky',
        icon: '01d',
        humidity: 50,
        windSpeed: 3.5,
      );
      final b = Weather(
        temperature: 25.0,
        feelsLike: 18.0,
        description: 'clear sky',
        icon: '01d',
        humidity: 50,
        windSpeed: 3.5,
      );
      expect(a, isNot(equals(b)));
    });
  });
}
