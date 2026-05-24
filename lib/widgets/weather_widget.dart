import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../l10n/l10n.dart';
import '../models/weather.dart';

class WeatherWidget extends StatelessWidget {
  final double lat;
  final double lng;

  const WeatherWidget({super.key, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    final l10n = context.read<L10n>();
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitial) {
          return _buildButton(context, lat, lng);
        }
        if (state is WeatherLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (state is WeatherLoaded) {
          return _buildWeatherCard(context, state.weather, l10n);
        }
        if (state is WeatherError) {
          return Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.translate('errorNetwork'), style: const TextStyle(color: Colors.orange)),
                  const SizedBox(height: 8),
                  _buildButton(context, lat, lng),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildButton(BuildContext context, double lat, double lng) {
    return ElevatedButton.icon(
      onPressed: () => context.read<WeatherBloc>().add(FetchWeather(lat, lng)),
      icon: const Icon(Icons.cloud),
      label: Text(context.read<L10n>().translate('weatherTitle')),
    );
  }

  Widget _buildWeatherCard(BuildContext context, Weather weather, L10n l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, size: 40),
                ),
                const SizedBox(width: 8),
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            Text(weather.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('${l10n.translate('feelsLike')}: ${weather.feelsLike.toStringAsFixed(1)}°C'),
            Text('${l10n.translate('humidity')}: ${weather.humidity}%'),
            Text('${l10n.translate('windSpeed')}: ${weather.windSpeed.toStringAsFixed(1)} ${l10n.translate('metersPerSecond')}'),
          ],
        ),
      ),
    );
  }
}
