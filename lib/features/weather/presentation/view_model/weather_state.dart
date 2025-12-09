import 'package:equatable/equatable.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/weather.dart';

enum WeatherStatus { initial, loading, success, failure }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather? currentWeather;
  final Forecast? forecast;
  final DateTime? lastUpdateTime;
  final String? errorMessage;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.currentWeather,
    this.forecast,
    this.lastUpdateTime,
    this.errorMessage,
  });

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? currentWeather,
    Forecast? forecast,
    DateTime? lastUpdateTime,
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentWeather,
    forecast,
    lastUpdateTime,
    errorMessage,
  ];
}
