/// Utility functions for date formatting and parsing
import 'package:intl/intl.dart';

class DateUtilsWB {
  static String formatDate(DateTime? dt, {String pattern = 'yyyy-MM-dd'}) {
    if (dt == null) return 'N/A';
    return DateFormat(pattern).format(dt.toLocal());
  }

  static DateTime? tryParse(String? dateStr) {
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }
}
