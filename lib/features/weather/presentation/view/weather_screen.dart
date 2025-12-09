import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forecast_weather/core/di/service_locator.dart';
import 'package:forecast_weather/core/utils/constants.dart';
import 'package:forecast_weather/core/utils/toast.dart';
import 'package:forecast_weather/core/widgets/custom_type_ahead_field.dart';
import 'package:forecast_weather/core/widgets/error_view.dart';

import 'package:forecast_weather/features/cities/domain/entities/city.dart';
import 'package:forecast_weather/features/cities/presentation/view_model/cities_cubit.dart';
import 'package:forecast_weather/features/cities/presentation/view_model/cities_state.dart';
import 'package:forecast_weather/features/weather/presentation/view_model/weather_cubit.dart';
import 'package:forecast_weather/features/weather/presentation/view_model/weather_state.dart';
import 'package:forecast_weather/features/weather/presentation/widgets/home_app_bar.dart';
import 'package:forecast_weather/features/weather/presentation/widgets/weather_content.dart';
import 'package:forecast_weather/features/weather/presentation/widgets/weather_empty_state_widget.dart';
import 'package:forecast_weather/features/weather/presentation/widgets/weather_loading_shimmer.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final cubit = sl<WeatherCubit>();
  final citiesCubit = sl<CitiesCubit>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: BlocProvider(
        create: (context) => cubit,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => cubit.refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<CitiesCubit, CitiesState>(
                    bloc: citiesCubit,
                    buildWhen: (previous, current) =>
                        previous.cities != current.cities,
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 20.w,
                        ),
                        child: CustomTypeAheadField<City>(
                          controller: _searchController,
                          debounceMs: AppConstants.searchDebounceMs,

                          suggestionsCallback: (query) async {
                            if (query.trim().isEmpty) return [];
                            await citiesCubit.searchCities(query);
                            return citiesCubit.state.cities;
                          },

                          itemTitleBuilder: (suggestion) {
                            final name = suggestion.name;
                            final country = suggestion.country;
                            return country.isNotEmpty
                                ? "$name, $country"
                                : name;
                          },

                          onSelected: (suggestion) {
                            cubit.fetchWeather(suggestion.name);
                            _searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      );
                    },
                  ),

                  BlocConsumer<WeatherCubit, WeatherState>(
                    listener: (context, state) {
                      if (state.status == WeatherStatus.failure &&
                          state.errorMessage != null) {
                        showToast(message: state.errorMessage!);
                      }
                    },
                    buildWhen: (previous, current) =>
                        previous.status != current.status ||
                        previous.currentWeather != current.currentWeather,
                    builder: (context, state) {
                      if (state.status == WeatherStatus.loading) {
                        return const WeatherLoadingShimmer();
                      }

                      if (state.status == WeatherStatus.failure &&
                          state.currentWeather == null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: ErrorView(
                            message: state.errorMessage ?? 'An error occurred',
                            onRetry: () => cubit.fetchWeather(
                              cubit.state.currentWeather?.cityName ?? 'London',
                            ),
                          ),
                        );
                      }

                      if (state.currentWeather == null) {
                        return const WeatherEmptyStateWidget();
                      }

                      return const WeatherContent();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
