import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String condition;
  final String description;
  final int conditionId;
  final String icon;
  final DateTime dateTime;
  final double? lat;
  final double? lon;

  const Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.condition,
    required this.description,
    required this.conditionId,
    required this.icon,
    required this.dateTime,
    this.lat,
    this.lon,
  });

  @override
  List<Object?> get props => [
    cityName,
    country,
    temperature,
    feelsLike,
    humidity,
    windSpeed,
    pressure,
    condition,
    description,
    conditionId,
    icon,
    dateTime,
    lat,
    lon,
  ];
}
