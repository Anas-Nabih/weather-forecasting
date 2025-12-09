import 'package:forecast_weather/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.country,
    required super.temperature,
    required super.feelsLike,
    required super.humidity,
    required super.windSpeed,
    required super.pressure,
    required super.condition,
    required super.description,
    required super.conditionId,
    required super.icon,
    required super.dateTime,
    super.lat,
    super.lon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] as String,
      country: json['sys']['country'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'] as int,
      condition: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      conditionId: json['weather'][0]['id'] as int,
      icon: json['weather'][0]['icon'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      lat: (json['coord']?['lat'] as num?)?.toDouble(),
      lon: (json['coord']?['lon'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {'country': country},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {
          'main': condition,
          'description': description,
          'id': conditionId,
          'icon': icon,
        },
      ],
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'coord': {if (lat != null) 'lat': lat, if (lon != null) 'lon': lon},
    };
  }
}
