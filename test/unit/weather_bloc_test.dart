import 'package:flutter_test/flutter_test.dart';
import 'package:vitmus/bloc/weather_bloc.dart';
import 'package:vitmus/models/weather.dart';
import 'package:vitmus/repositories/weather_repository.dart';

class MockWeatherRepository implements WeatherRepository {
  Future<Weather> Function()? mockGetWeather;

  @override
  Future<Weather> getWeather(double lat, double lng) {
    if (mockGetWeather != null) return mockGetWeather!();
    throw UnimplementedError('mockGetWeather not set');
  }
}

void main() {
  late MockWeatherRepository repository;
  late WeatherBloc bloc;

  setUp(() {
    repository = MockWeatherRepository();
    bloc = WeatherBloc(repository);
  });

  tearDown(() {
    bloc.close();
  });

  group('WeatherBloc', () {
    const testLat = 55.19;
    const testLng = 30.20;

    test('initial state is WeatherInitial', () {
      expect(bloc.state, const WeatherInitial());
    });

    test('emits [WeatherLoading, WeatherLoaded] on FetchWeather', () async {
      repository.mockGetWeather = () async => const Weather(
        temperature: 20.0,
        feelsLike: 18.0,
        description: 'clear sky',
        icon: '01d',
        humidity: 50,
        windSpeed: 3.5,
      );

      final expected = [
        const WeatherLoading(),
        isA<WeatherLoaded>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const FetchWeather(testLat, testLng));
    });

    test('emits WeatherError when repository throws', () async {
      repository.mockGetWeather = () => throw Exception('Network error');

      final expected = [
        const WeatherLoading(),
        isA<WeatherError>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const FetchWeather(testLat, testLng));
    });
  });
}
