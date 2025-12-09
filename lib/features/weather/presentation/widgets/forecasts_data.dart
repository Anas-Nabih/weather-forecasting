import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forecast_weather/features/weather/domain/entities/forecast.dart';
import 'package:forecast_weather/features/weather/presentation/widgets/forecast_card.dart';

class ForecastsData extends StatelessWidget {
  const ForecastsData({
    super.key,
    required this.forecasts,
    required this.label,
  });

  final List<ForecastItem> forecasts;
  final String label;

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecasts.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 130,
                child: ForecastCard(
                  key: ValueKey('forecast_$index'),
                  forecast: forecasts[index],
                  index: index,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
