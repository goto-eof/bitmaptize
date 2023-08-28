
import 'package:bitmaptize/widget/bitmaptize.dart';
import 'package:flutter/material.dart';

main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.cyan,
      ),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.black),
      themeMode: ThemeMode.system,
      home: const Bitmaptize(),
    ),
  );
}
