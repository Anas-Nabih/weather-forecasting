import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forecast_weather/core/utils/extensions/context_extension.dart';
import 'package:forecast_weather/core/utils/extensions/datetime_extension.dart';

import 'package:forecast_weather/core/utils/extensions/num_extension.dart';
import 'package:forecast_weather/core/utils/extensions/string_extension.dart';
import 'package:forecast_weather/features/weather/domain/entities/forecast.dart';
import 'package:forecast_weather/features/weather/domain/entities/weather.dart';

import 'package:forecast_weather/features/weather/presentation/view_model/weather_cubit.dart';
import 'package:forecast_weather/features/weather/presentation/view_model/weather_state.dart';
import 'package:forecast_weather/features/weather/presentation/widgets/forecasts_data.dart';
import 'package:forecast_weather/features/weather/presentation/widgets/weather_details_grid.dart';
import 'package:lottie/lottie.dart';

class WeatherContent extends StatelessWidget {
  const WeatherContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          BlocSelector<WeatherCubit, WeatherState, Weather?>(
            selector: (state) => state.currentWeather,
            builder: (context, weather) {
              if (weather == null) return const SizedBox.shrink();

              final lastUpdateTime = context
                  .read<WeatherCubit>()
                  .state
                  .lastUpdateTime;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  weather.cityName,
                                  style: context.textTheme.headlineMedium,
                                ),
                                Text(
                                  weather.country,
                                  style: context.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 120.h,
                        child: Lottie.asset(
                          weather.conditionId.weatherAnimation,
                          fit: BoxFit.cover,
                          repeat: true,
                        ),
                      ),
                      Text(
                        weather.temperature.toTemperature(),
                        style: context.textTheme.displayLarge?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather.description.capitalizeWords(),
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Feels like ${weather.feelsLike.toTemperature()}',
                        style: context.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      if (lastUpdateTime != null)
                        Text(
                          'Last updated: ${lastUpdateTime.toRelativeTime()}',
                          style: context.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          BlocSelector<WeatherCubit, WeatherState, Weather?>(
            selector: (state) => state.currentWeather,
            builder: (context, weather) {
              if (weather == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: WeatherDetailsGrid(weather: weather),
              );
            },
          ),
          BlocSelector<WeatherCubit, WeatherState, List<ForecastItem>>(
            selector: (state) =>
                state.forecast?.forecasts.take(8).toList() ?? [],
            builder: (context, hourlyForecasts) {
              if (hourlyForecasts.isEmpty) return const SizedBox.shrink();
              return ForecastsData(
                label: 'Hourly Forecast',
                forecasts: hourlyForecasts,
              );
            },
          ),
          SizedBox(height: 22.h),
          BlocSelector<WeatherCubit, WeatherState, List<ForecastItem>>(
            selector: (state) => context.read<WeatherCubit>().getDailyForecasts,
            builder: (context, dailyForecasts) {
              if (dailyForecasts.isEmpty) return const SizedBox.shrink();
              return ForecastsData(
                label: '7-Day Forecast',
                forecasts: dailyForecasts,
              );
            },
          ),
        ],
      ),
    );
  }
}
