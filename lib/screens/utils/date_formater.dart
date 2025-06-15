class DateFormatter {

  static String formatRequestDate(String isoDateString) {
    try {
      DateTime dateTime = DateTime.parse(isoDateString);

      String month = _getMonthName(dateTime.month);
      String day = dateTime.day.toString();
      String year = dateTime.year.toString();

      String time = _formatTime(dateTime.hour, dateTime.minute);

      return '$month $day, $year at $time';
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

}