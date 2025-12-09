import 'package:forecast_weather/features/cities/domain/entities/city.dart';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/api_service.dart';
import '../models/city_model.dart';

class CitiesRepository {
  final ApiService _apiService;

  CitiesRepository(this._apiService);

  Future<Either<Failure, List<City>>> searchCities(String query) async {
    try {
      final results = await _apiService.searchCities(query);
      final cities = results.map((data) => CityModel.fromJson(data)).toList();
      return Right(cities);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: $e'));
    }
  }
}
