import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utility for working with dates.
class DateTimeUtil {
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

  /// for [Date]

  // Formats DateTime to a readable string

  static String formatDate(DateTime date) {
    final dateFormat =
        DateFormat('yyyy-MM-dd'); // Customize the format as needed
    return dateFormat.format(date);
  }

  // Parses a date string in ISO 8601 format to a DateTime object
  static DateTime parseDate(String dateStr) {
    return DateTime.parse(dateStr);
  }

  /// for [Time]

  // Formats TimeOfDay to a readable string (HH:mm)
  static String formatTime(BuildContext context, TimeOfDay time) {
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }

  //for toJson() method
  // Parses a time string (HH:mm) to a TimeOfDay object
  static TimeOfDay parseTime(String timeStr) {
    final timeParts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  // Date & Time picker Dialogs

  static Future<DateTime?> showDateTimePickerDialog(BuildContext context,
      {DateTime? initialDate}) async {
    DateTime? selectedDateTime = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime? dateTime;
        return AlertDialog(
          title: const Text('Choose Date & Time'),
          content: DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'd MMM, yyyy',
            initialDate: initialDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            onChanged: (val) => dateTime = DateTime.parse(val),
            onSaved: (val) =>
                dateTime = val != null ? DateTime.parse(val) : null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(dateTime);
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
    return selectedDateTime;
  }
}

extension on TimeOfDay {
  //  Convert TimeOfDay to string (HH:mm)
  /// ignore: unused_element
  String get toStr {
    return "$hour:$minute";
  }
}

/*
  // Convert the PostModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'arrivalDate': DateUtil.formatDate(arrivalDate), // Use DateUtil for date formatting
      'arrivalTime': '${arrivalTime.hour}:${arrivalTime.minute}', // Convert TimeOfDay to string (HH:mm)
      'cityName': cityName,
    };
  }

  // Create a PostModel from a JSON map
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      arrivalDate: DateUtil.parseDate(json['arrivalDate']), // Use DateUtil for date parsing
      arrivalTime: TimeUtil.parseTime(json['arrivalTime']), // Use TimeUtil for time parsing
      cityName: json['cityName'],
    );
  }
 */
