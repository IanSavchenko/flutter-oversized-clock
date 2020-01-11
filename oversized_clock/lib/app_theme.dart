import 'package:flutter/material.dart';

class AppTheme {
  Color background;
  Color text;

  AppTheme({this.background, this.text});

  static AppTheme light =
      AppTheme(background: Colors.white, text: Colors.black);

  static AppTheme dark = AppTheme(background: Colors.black, text: Colors.white);

  static AppTheme forContext(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? light : dark;
  }
}
