class DataUpdateException implements Exception {
  final String message;
  DataUpdateException(this.message);

  @override
  String toString() => message;
}