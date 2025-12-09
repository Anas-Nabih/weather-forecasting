import 'package:forecast_weather/features/weather/domain/entities/forecast.dart';

class ForecastItemModel extends ForecastItem {
  const ForecastItemModel({
    required super.dateTime,
    required super.temperature,
    required super.feelsLike,
    required super.humidity,
    required super.windSpeed,
    required super.pressure,
    required super.condition,
    required super.description,
    required super.conditionId,
    required super.icon,
    super.pop,
  });

  factory ForecastItemModel.fromJson(Map<String, dynamic> json) {
    return ForecastItemModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'] as int,
      condition: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      conditionId: json['weather'][0]['id'] as int,
      icon: json['weather'][0]['icon'] as String,
      pop: (json['pop'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
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
      if (pop != null) 'pop': pop,
    };
  }
}

class ForecastModel extends Forecast {
  const ForecastModel({
    required super.cityName,
    required super.country,
    required List<ForecastItemModel> forecasts,
  }) : super(forecasts: forecasts);

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List<dynamic>;
    final forecasts = list
        .map((item) => ForecastItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return ForecastModel(
      cityName: json['city']['name'] as String,
      country: json['city']['country'] as String,
      forecasts: forecasts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': {'name': cityName, 'country': country},
      'list': forecasts.map((f) {
        if (f is ForecastItemModel) {
          return f.toJson();
        } else {
          // Fallback or error if we have pure entities mixed in data layer
          // For now assuming we maintain models in data flow
          // Re-create model to optimize? No, just throw or log.
          // But actually we can create a temporary model to serialize if needed.
          return {
            'dt': f.dateTime.millisecondsSinceEpoch ~/ 1000,
            'main': {
              'temp': f.temperature,
              'feels_like': f.feelsLike,
              'humidity': f.humidity,
              'pressure': f.pressure,
            },
            'wind': {'speed': f.windSpeed},
            'weather': [
              {
                'main': f.condition,
                'description': f.description,
                'id': f.conditionId,
                'icon': f.icon,
              },
            ],
            if (f.pop != null) 'pop': f.pop,
          };
        }
      }).toList(),
    };
  }
}
