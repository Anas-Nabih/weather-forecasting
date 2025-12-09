import 'package:flutter/material.dart';
import 'package:forecast_weather/features/weather/domain/entities/weather.dart';
import 'package:forecast_weather/features/weather/presentation/widgets/weather_info_card.dart';

class WeatherDetailsGrid extends StatelessWidget {
  const WeatherDetailsGrid({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: [
        WeatherInfoCard(
          icon: Icons.water_drop,
          label: 'Humidity',
          value: '${weather.humidity}%',
        ),
        WeatherInfoCard(
          icon: Icons.air,
          label: 'Wind',
          value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
        ),
        WeatherInfoCard(
          icon: Icons.compress,
          label: 'Pressure',
          value: '${weather.pressure} hPa',
        ),
      ],
    );
  }
}
