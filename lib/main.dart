import 'dart:io';

import 'package:bitmaptize/service/bitmap_to_data_file_converter.dart';
import 'package:bitmaptize/service/data_file_to_bitmap_converter.dart';

main() async {
  const String path = "/home/andrei/Desktop/toEncrypt";
  //const targetFileName = "$path/strategy_design_pattern.zip";
  const targetFileName = "/home/andrei/Desktop/bmp7x7_24bit.bmp";
  //const targetFileName =
  //  "$path/virtualbox-7.0_7.0.10-158379~Ubuntu~jammy_amd64.deb";
  //const targetFileName = "$path/test.txt";
  //const targetFileName =
  "/home/andrei/Desktop/toEncrypt/neon-user-20230727-0716.iso";
  const destinationFilename = "$targetFileName.bmp";

  await DataFileToBitmapConverter()
      .convert(targetFileName, destinationFilename);

  await BitmapToDataFileConverter()
      .convert(destinationFilename, "$targetFileName.2.deb");
  exit(0);
}
