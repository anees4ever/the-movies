import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String quickFormat(String format) {
    return DateFormat(format).format(this);
  }
}
