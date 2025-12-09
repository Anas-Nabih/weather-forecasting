extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  bool get isValidCityName {
    if (isEmpty || length < 2) return false;
    final regex = RegExp(r"^[a-zA-Z\s\-']+$");
    return regex.hasMatch(this);
  }
}
