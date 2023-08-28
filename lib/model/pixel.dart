class Pixel {
  Pixel({required this.blue, required this.green, required this.red});
  final int blue;
  final int green;
  final int red;
  @override
  String toString() {
    return "[blue: $blue, green: $green, red: $red]";
  }
}
