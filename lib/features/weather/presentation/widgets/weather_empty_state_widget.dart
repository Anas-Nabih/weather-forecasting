import 'package:flutter/material.dart';
import 'package:forecast_weather/core/utils/extensions/context_extension.dart';

class WeatherEmptyStateWidget extends StatelessWidget {
  const WeatherEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              size: 100,
              color: context.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text('No Weather Data', style: context.textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              'Search for a city to see the weather forecast',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
