import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/cities_repository.dart';
import 'cities_state.dart';

class CitiesCubit extends Cubit<CitiesState> {
  final CitiesRepository _citiesRepository;

  CitiesCubit(this._citiesRepository) : super(const CitiesState());

  Future<void> searchCities(String query) async {
    if (query.isEmpty) {
      clearSearch();
      return;
    }

    emit(state.copyWith(status: CitiesStatus.loading));

    final result = await _citiesRepository.searchCities(query);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CitiesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (cities) =>
          emit(state.copyWith(status: CitiesStatus.success, cities: cities)),
    );
  }

  void clearSearch() {
    emit(state.copyWith(status: CitiesStatus.initial, cities: []));
  }
}
