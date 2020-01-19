import 'package:flutter/material.dart';

class AppTheme {
  final List<Color> backgroundColors;
  final Color frontTextColor;
  final Color backTextColor;

  AppTheme({this.backgroundColors, this.frontTextColor, this.backTextColor});

  static AppTheme light = AppTheme(backgroundColors: [
    Color.fromRGBO(0x50, 0xc9, 0xc3, 1),
    Color.fromRGBO(0x27, 0x80, 0x7c, 1)
  ], frontTextColor: Colors.white, backTextColor: Colors.black12);

  static AppTheme dark = AppTheme(backgroundColors: [
    Color.fromRGBO(0x09, 0x20, 0x3f, 1),
    Color.fromRGBO(0x53, 0x78, 0x95, 1)
  ], frontTextColor: Colors.grey[200], backTextColor: Colors.black26);

  static AppTheme forContext(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? light : dark;
  }
}
