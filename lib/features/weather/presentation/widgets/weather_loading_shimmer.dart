import 'package:flutter/material.dart';
import 'package:forecast_weather/core/widgets/loading_shimmer.dart';

class WeatherLoadingShimmer extends StatelessWidget {
  const WeatherLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          WeatherCardShimmer(),
          SizedBox(height: 24),
          ForecastListShimmer(),
        ],
      ),
    );
  }
}
