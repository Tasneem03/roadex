class DateFormatter {

  /// Formats ISO date string to readable format without external packages
  /// Input: "2025-06-13T00:29:58.6018538"
  /// Output: "Jun 13, 2025 at 12:29 AM"
  static String formatRequestDate(String isoDateString) {
    try {
      // Parse the ISO date string
      DateTime dateTime = DateTime.parse(isoDateString);

      // Get components
      String month = _getMonthName(dateTime.month);
      String day = dateTime.day.toString();
      String year = dateTime.year.toString();

      // Format time
      String time = _formatTime(dateTime.hour, dateTime.minute);

      return '$month $day, $year at $time';
    } catch (e) {
      // Return original string if parsing fails
      return isoDateString;
    }
  }

  /// Simple date only format
  /// Output: "Jun 13, 2025"
  static String formatDateOnly(String isoDateString) {
    try {
      DateTime dateTime = DateTime.parse(isoDateString);

      String month = _getMonthName(dateTime.month);
      String day = dateTime.day.toString();
      String year = dateTime.year.toString();

      return '$month $day, $year';
    } catch (e) {
      return isoDateString;
    }
  }

  /// Simple time only format
  /// Output: "12:29 AM"
  static String formatTimeOnly(String isoDateString) {
    try {
      DateTime dateTime = DateTime.parse(isoDateString);
      return _formatTime(dateTime.hour, dateTime.minute);
    } catch (e) {
      return isoDateString;
    }
  }

  /// Short format
  /// Output: "13/06/2025"
  static String formatDateShort(String isoDateString) {
    try {
      DateTime dateTime = DateTime.parse(isoDateString);

      String day = dateTime.day.toString().padLeft(2, '0');
      String month = dateTime.month.toString().padLeft(2, '0');
      String year = dateTime.year.toString();

      return '$day/$month/$year';  // or '$month/$day/$year' for US format
    } catch (e) {
      return isoDateString;
    }
  }

  /// Helper method to get month name
  static String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  /// Helper method to format time in 12-hour format
  static String _formatTime(int hour, int minute) {
    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    String minuteStr = minute.toString().padLeft(2, '0');

    return '$displayHour:$minuteStr $period';
  }

  /// Alternative: 24-hour format
  static String formatDateTime24Hour(String isoDateString) {
    try {
      DateTime dateTime = DateTime.parse(isoDateString);

      String month = _getMonthName(dateTime.month);
      String day = dateTime.day.toString();
      String year = dateTime.year.toString();
      String hour = dateTime.hour.toString().padLeft(2, '0');
      String minute = dateTime.minute.toString().padLeft(2, '0');

      return '$month $day, $year at $hour:$minute';
    } catch (e) {
      return isoDateString;
    }
  }

  /// Relative time without external packages
  static String formatRelativeTime(String isoDateString) {
    try {
      DateTime dateTime = DateTime.parse(isoDateString);
      DateTime now = DateTime.now();

      Duration difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hr ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        // Show full date for older items
        return formatDateOnly(isoDateString);
      }
    } catch (e) {
      return isoDateString;
    }
  }
}