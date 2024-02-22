import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatService {
  static String dateFormatWithMonthNameTime(date) =>
      DateFormat("MMM,dd yyyy hh:mm:a").format(date);

}
