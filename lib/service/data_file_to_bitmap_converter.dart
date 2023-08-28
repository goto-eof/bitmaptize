import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bitmaptize/model/pixel.dart';
import 'package:bitmaptize/service/validation_util.dart';

class DataFileToBitmapConverter {
  final List<int> bitmapSignatureBytes = utf8.encode("BM");
  final int headerFullLength = 54;
  final maxWidth = 6000; //30194 - 24194;
  final int sizeOfThisHeader = 40;
  final int numberOfColorPlanes = 1;
  final int colorDepth = 24;
  final int compressionMethod = 0;

  Future<List<Pixel>> _fileBytesToPixels(
      Uint8List data, final String targetFileName) async {
    List<Pixel> pixels = [];
    int i = 0;
    while (i < data.length + 3) {
      pixels.add(Pixel(
        blue: i < data.length ? data[i] : 255,
        green: i + 1 < data.length ? data[i + 1] : 255,
        red: i + 2 < data.length ? data[i + 2] : 255,
      ));
      i += 3;
    }

    int numberOfPixels = pixels.length;
    if (numberOfPixels > maxWidth) {
      final int numberOfBlankPixelToGenerate = numberOfPixels % maxWidth;
      for (int i = 0; i < numberOfBlankPixelToGenerate; i++) {
        pixels.add(Pixel(
          blue: 255,
          green: 255,
          red: 255,
        ));
      }
      numberOfPixels = pixels.length;
    }

    return pixels;
  }

  void _writeHeaderOnBuffer(final ByteData byteData, final int fullFileSize) {
    byteData.setUint8(0, bitmapSignatureBytes[0]);
    byteData.setUint8(1, bitmapSignatureBytes[1]);
    byteData.setInt32(2, fullFileSize, Endian.little);
    byteData.setUint32(6, 0, Endian.little);
    byteData.setInt32(10, headerFullLength, Endian.little);
  }

  void _writeInfoHeaderOnBuffer(final ByteData byteData, final int width,
      final int height, final int numberOfPixels, final int dataLength) {
    byteData.setInt32(14, sizeOfThisHeader, Endian.little);
    byteData.setInt32(18, width, Endian.little);
    byteData.setInt32(22, height, Endian.little);
    byteData.setInt16(26, numberOfColorPlanes, Endian.little);
    byteData.setInt16(28, colorDepth, Endian.little);
    byteData.setInt32(30, compressionMethod, Endian.little);
    byteData.setInt32(34, dataLength, Endian.little);
    byteData.setInt32(38, 0, Endian.little);
    byteData.setInt32(42, 0, Endian.little);
    byteData.setInt32(46, 0, Endian.little);
    byteData.setInt32(50, 0, Endian.little);
  }

  Future<void> _writeOnFile(
      final String destinationFilename, Uint8List data) async {
    File outFile = File(destinationFilename);
    await outFile.writeAsBytes(data);
  }

  void _writeFileDataOnBuffer(List<Pixel> pixels, ByteData byteData) {
    int pos = 54;
    for (Pixel pixel in pixels) {
      byteData.setInt8(pos++, pixel.blue);
      byteData.setInt8(pos++, pixel.green);
      byteData.setInt8(pos++, pixel.red);
    }
  }

  Future<void> convert(
      final String targetFileName, final String destinationFilename) async {
    File inFile = File(targetFileName);
    Uint8List data = await inFile.readAsBytes();
    ValidationUtil.validate(data);
    List<Pixel> pixels = await _fileBytesToPixels(data, targetFileName);
    int width = (pixels.length > maxWidth) ? maxWidth : pixels.length;
    final int height = (pixels.length / width).round();
    final fullFileSize = pixels.length * 3 + headerFullLength;
    ByteData byteData = ByteData(fullFileSize);
    _writeHeaderOnBuffer(byteData, fullFileSize);
    _writeInfoHeaderOnBuffer(
        byteData, width, height, pixels.length, data.length);
    _writeFileDataOnBuffer(pixels, byteData);
    await _writeOnFile(destinationFilename, byteData.buffer.asUint8List());
  }
}
