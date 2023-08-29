class InvalidFileException implements Exception {
  InvalidFileException(this.cause);
  final String cause;
}
