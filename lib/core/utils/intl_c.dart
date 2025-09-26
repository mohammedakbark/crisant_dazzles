import 'package:intl/intl.dart';

class IntlC {
  static final _dateFormat = DateFormat('dd-MM-yyyy');
  static final _timeFormat = DateFormat('hh:mm a');
  static final _dateTimeFormat = DateFormat('dd-MM-yyyy HH:mm a');
  static final _monthDayYearFormat = DateFormat('MMMM dd, yyyy');
  static final _yearMonthDayeFormat = DateFormat('yyyy-MM-dd');

  static String convertToDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String monthDayYear(DateTime date) {
    return _monthDayYearFormat.format(date);
  }

  static String convertToTime(DateTime date) {
    return _timeFormat.format(date);
  }

  static String convertToDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  static String convertToYearMonthDay(DateTime date) {
    return _yearMonthDayeFormat.format(date);
  }
}
