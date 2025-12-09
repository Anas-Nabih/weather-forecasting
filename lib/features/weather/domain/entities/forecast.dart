import 'package:equatable/equatable.dart';

class ForecastItem extends Equatable {
  final DateTime dateTime;
  final double feelsLike;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String condition;
  final String description;
  final int conditionId;
  final double? pop;
  final String icon;

  const ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.condition,
    required this.description,
    required this.conditionId,
    required this.icon,
    this.pop,
  });

  @override
  List<Object?> get props => [
    dateTime,
    feelsLike,
    temperature,
    humidity,
    windSpeed,
    pressure,
    condition,
    description,
    conditionId,
    pop,
    icon,
  ];
}

class Forecast extends Equatable {
  final String cityName;
  final String country;
  final List<ForecastItem> forecasts;

  const Forecast({
    required this.cityName,
    required this.country,
    required this.forecasts,
  });

  List<ForecastItem> getDailyForecasts({int days = 7}) {
    final Map<String, ForecastItem> dailyMap = {};

    for (final forecast in forecasts) {
      final dateKey =
          '${forecast.dateTime.year}-${forecast.dateTime.month}-${forecast.dateTime.day}';

      if (!dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey] = forecast;
      } else {
        final existing = dailyMap[dateKey]!;
        final currentHour = forecast.dateTime.hour;
        final existingHour = existing.dateTime.hour;

        if ((currentHour - 12).abs() < (existingHour - 12).abs()) {
          dailyMap[dateKey] = forecast;
        }
      }
    }

    final result = dailyMap.values.toList();
    result.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return result.take(days).toList();
  }

  @override
  List<Object?> get props => [cityName, country, forecasts];
}
