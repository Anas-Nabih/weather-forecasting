import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomTypeAheadField<T> extends StatelessWidget {
  final TextEditingController controller;
  final Future<List<T>> Function(String query) suggestionsCallback;
  final void Function(T suggestion) onSelected;
  final String Function(T suggestion) itemTitleBuilder;
  final InputDecoration? inputDecoration;
  final int debounceMs;

  const CustomTypeAheadField({
    super.key,
    required this.controller,
    required this.suggestionsCallback,
    required this.onSelected,
    required this.itemTitleBuilder,
    this.inputDecoration,
    this.debounceMs = 400,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TypeAheadField<T>(
      controller: controller,
      debounceDuration: Duration(milliseconds: debounceMs),

      suggestionsCallback: suggestionsCallback,

      builder: (context, textController, focusNode) {
        return TextField(
          controller: textController,
          focusNode: focusNode,
          style: TextStyle(
            color: isDarkMode ? Colors.white.withValues(alpha: 0.8) : Colors.black,
          ),
          decoration:
              inputDecoration ??
              InputDecoration(
                hintText: 'Enter city name',
                hintStyle: TextStyle(
                  color: isDarkMode
                      ? Colors.white.withValues(alpha:0.8)
                      : Colors.black,
                ),
                filled: true,
                fillColor: isDarkMode
                    ? Colors.blueAccent.withValues(alpha:0.2)
                    : const Color.fromARGB(172, 243, 240, 240),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: const Icon(Icons.search, color: Colors.blueAccent),
              ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onSelected(value as T);
              controller.clear();
              FocusScope.of(context).unfocus();
            }
          },
        );
      },

      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(
            itemTitleBuilder(suggestion),
            style: TextStyle(
              color: isDarkMode ? Colors.white.withValues(alpha:0.8) : Colors.black,
            ),
          ),
        );
      },

      onSelected: (suggestion) => onSelected(suggestion),

      decorationBuilder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white.withValues(alpha:0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          constraints: const BoxConstraints(maxHeight: 200),
          child: child,
        );
      },
      emptyBuilder: (context) =>const SizedBox.shrink() ,
    );
  }
}
