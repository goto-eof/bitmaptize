class FileToLargeException implements Exception {
  FileToLargeException(this.cause);
  final String cause;
}
