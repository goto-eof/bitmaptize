class FileUtil {
  static RegExp regExp = RegExp(r'.*(?=\.)');

  static String removeLastFileNameExtension(String filePathAndName) {
    return regExp.firstMatch(filePathAndName)![0]!;
  }
}
