class NoDataRetrievedException implements Exception {
  const NoDataRetrievedException({this.message = 'data'});

  final String message;

  @override
  String toString() {
    return "Error : Unable to retrieve $message";
  }
}
