import 'dart:typed_data';

import 'package:bitmaptize/exception/file_too_large_exception.dart';

class ValidationUtil {
  static void validate(Uint8List data) {
    if (data.length > 1048576 * 100) {
      throw FileToLargeException("File to large");
    }
  }
}
