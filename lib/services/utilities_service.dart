import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utilities {
  static String formatXAxisLabel(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat formatDate = new DateFormat.Md();
    return formatDate.format(dateTime);
  }

  static String formatChartHeaderDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat formatDate = DateFormat.yMMMMEEEEd();
    return formatDate.format(dateTime);
  }

  static String formatDate(DateTime date) {
    DateFormat formatDate = new DateFormat('yyyy-MM-dd');
    return formatDate.format(date);
  }

  static String formatTime(DateTime date) {
    DateFormat formatDate = new DateFormat('jm');
    return formatDate.format(date);
  }

  static String getCurrentDayId() {
    DateTime currentDate = DateTime.now();
    return formatDate(currentDate);
  }

  static String getLastWeekStartDayId(DateTime date) {
    DateTime firstDayOfLastWeek = date.subtract(Duration(days: 7));

    String dayId = formatDate(firstDayOfLastWeek);
    // print('LAST WEEK START DAY ID: ' + dayId.toString());

    return dayId;
  }

  static List<String> getDayIds(String startDay, String endDay) {
    List<String> dayIds = [];

    // find how many days to go back
    DateTime startingDate = DateTime.parse(startDay);
    DateTime endingDate = DateTime.parse(endDay);
    int noOfDaysToGoBack = (endingDate.difference(startingDate)).inDays;

    for (int i = noOfDaysToGoBack; i >= 0; i--) {
      DateTime day = endingDate.subtract(Duration(days: i));
      dayIds.add(formatDate(day));
    }

    // print('GETTTTT DAY IDS: ' + dayIds.toString());

    return dayIds;
  }

  static String getLastTwoWeeksStartDayId(DateTime date) {
    DateTime firstDayOfLastTwoWeeks = date.subtract(Duration(days: 14));

    String dayId = formatDate(firstDayOfLastTwoWeeks);
    print('LAST TWO WEEKS START DAY ID: ' + dayId.toString());

    return dayId;
  }

  static String getLastMonthStartDayId(DateTime date) {
    DateTime firstDayOfLastMonth =
        new DateTime(date.year, date.month - 1, date.day);

    String dayId = formatDate(firstDayOfLastMonth);
    print('LAST MONTH START DAY ID: ' + dayId.toString());

    return dayId;
  }

  static String getLastThreeMonthsStartDayId(DateTime date) {
    DateTime firstDayOfLastThreeMonths =
        new DateTime(date.year, date.month - 2, date.day);

    String dayId = formatDate(firstDayOfLastThreeMonths);
    print('LAST THREE MONTH START DAY ID: ' + dayId.toString());

    return dayId;
  }

  static String getLastSixMonthsStartDayId(DateTime date) {
    DateTime firstDayOfLastSixMonth =
        new DateTime(date.year, date.month - 5, date.day);

    String dayId = formatDate(firstDayOfLastSixMonth);
    print('LAST SIX MONTH START DAY ID: ' + dayId.toString());

    return dayId;
  }

  static Color gradedColors(double? value) {
    if (value == null) {
      return Colors.grey;
    }
    if (value < 25) {
      return Color(0xFFE00406);
    } else if (value >= 25 && value < 40) {
      return Color(0xFFE76005);
    } else if (value >= 40 && value < 55) {
      return Color(0xFF44B11B);
    } else if (value >= 55 && value < 70) {
      return Color(0xFF22BDD5);
    } else if (value >= 70 && value < 90) {
      return Color(0xFF1A0DC6);
    } else if (value >= 90) {
      return Color(0xFFE7E507);
    } else {
      return Colors.grey;
    }
  }

  static String roundOffPercentageValue(double percentage) {
    int intVal = percentage.toInt();
    double decimalVal = percentage - intVal;
    int percentageValue = decimalVal > 0.5 ? (intVal + 1) : intVal;

    return percentageValue.toString();
  }

  static int roundOffPercentageValueToInt(double percentage) {
    int intVal = percentage.toInt();

    double decimalVal = percentage - intVal;
    int percentageValue = decimalVal > 0.5 ? (intVal + 1) : intVal;

    return percentageValue;
  }
}
