import 'package:forecast_weather/core/utils/constants.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toReadableDate() {
    return DateFormat('d MMM, y').format(this);
  }

  String toReadableTime() {
    return DateFormat('h:mm a').format(this);
  }

  String toFullFormat() {
    return DateFormat('MMM d, y h:mm a').format(this);
  }

  String toDayName() {
    return DateFormat('EEEE').format(this);
  }

  String toShortDayName() {
    return DateFormat('EEE').format(this);
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isCacheValid({int validityHours = AppConstants.cacheValidityHours}) {
    final now = DateTime.now();
    final difference = now.difference(this);
    return difference.inHours < validityHours;
  }

  String toRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else {
      return toReadableDate();
    }
  }
}
