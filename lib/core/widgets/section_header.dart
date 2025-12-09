import 'package:flutter/material.dart';
import 'package:forecast_weather/core/utils/extensions/context_extension.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key,  required this.title});

   final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
