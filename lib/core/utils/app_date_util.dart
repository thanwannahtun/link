/// Utility for working with dates.
class AppDateUtil {
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Unknown";

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$day-$month-$year $hour:$minute $amPm';
  }
}
