class Utils {
  static String formatNumber0Left(int number, int len) {
    String ret = number.toString();
    if (ret.length < len) {
      for (int i = 1; i < len; i++) {
        ret = '0' + ret;
      }
    }

    return ret;
  }

  static String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${formatNumber0Left(dateTime.month, 2)}/${dateTime.year}';
  }
}
