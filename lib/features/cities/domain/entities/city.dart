import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String? state;

  const City({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
  });

  @override
  List<Object?> get props => [name, lat, lon, country, state];
}
