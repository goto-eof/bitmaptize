import 'dart:typed_data';

class ValidationUtil {
  static void validate(Uint8List data) {
    if (data.length > 1048576 * 100) {
      throw Exception("File to large");
    }
  }
}
