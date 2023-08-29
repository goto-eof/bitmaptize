import 'dart:io';
import 'dart:typed_data';

import 'package:bitmaptize/exception/file_too_large_exception.dart';
import 'package:bitmaptize/exception/invalid_file_exception.dart';
import 'package:bitmaptize/service/validation_util.dart';

class BitmapToDataFileConverter {
  Future<void> convert(
      final String targetFileName, final String destinationFileName) async {
    try {
      await _convert(targetFileName, destinationFileName);
    } on FileToLargeException catch (exc) {
      rethrow;
    } catch (err) {
      throw InvalidFileException("Something went wrong: $err");
    }
  }

  Future<void> _convert(
      final String targetFileName, final String destinationFileName) async {
    File inFile = File(targetFileName);
    Uint8List data = await inFile.readAsBytes();
    ValidationUtil.validate(data);
    ByteData byteData = ByteData.view(data.buffer);
    int size = byteData.getInt32(34, Endian.little).toInt();
    File destinationFile = File(destinationFileName);
    final Uint8List listOfBytes = byteData.buffer.asUint8List();
    final ByteData writeByteBuffer = ByteData(size);
    for (int i = 54; i < 54 + size; i++) {
      writeByteBuffer.setUint8(i - 54, listOfBytes[i]);
    }
    var dataToWrite = writeByteBuffer.buffer.asUint8List();
    await destinationFile.writeAsBytes(dataToWrite);
  }
}
