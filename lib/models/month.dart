class Month {
  static const monthString = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static final monthStringShorten =
      monthString.toList().map((e) => e.substring(0, 3)).toList();

  static String fromIntToString(int i) {
    return monthString[i - 1];
  }

  static String fromIntToStringShorten(int i) {
    return monthStringShorten[i - 1];
  }

  static int fromStringtoInt(String month) {
    return monthString.indexOf(month) + 1;
  }
}
