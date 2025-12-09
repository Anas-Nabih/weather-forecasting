import 'package:equatable/equatable.dart';
import '../../domain/entities/city.dart';

enum CitiesStatus { initial, loading, success, failure }

class CitiesState extends Equatable {
  final CitiesStatus status;
  final List<City> cities;
  final String? errorMessage;

  const CitiesState({
    this.status = CitiesStatus.initial,
    this.cities = const [],
    this.errorMessage,
  });

  CitiesState copyWith({
    CitiesStatus? status,
    List<City>? cities,
    String? errorMessage,
  }) {
    return CitiesState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cities, errorMessage];
}
