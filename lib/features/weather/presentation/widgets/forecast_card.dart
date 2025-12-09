import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forecast_weather/core/utils/extensions/datetime_extension.dart';
import 'package:forecast_weather/core/utils/extensions/num_extension.dart';
import 'package:forecast_weather/core/utils/extensions/string_extension.dart';
import 'package:forecast_weather/features/weather/domain/entities/forecast.dart';
import 'package:lottie/lottie.dart';

class ForecastCard extends StatefulWidget {
  final ForecastItem forecast;
  final int index;

  const ForecastCard({super.key, required this.forecast, required this.index});

  @override
  State<ForecastCard> createState() => _ForecastCardState();
}

class _ForecastCardState extends State<ForecastCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 50)),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.forecast.dateTime.toShortDayName(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.forecast.dateTime.toReadableDate(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: 45.r,
                  width: 45.r,
                  child: Lottie.asset(
                    widget.forecast.conditionId.weatherAnimation,
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  widget.forecast.temperature.toTemperature(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.forecast.description.capitalizeWords(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
