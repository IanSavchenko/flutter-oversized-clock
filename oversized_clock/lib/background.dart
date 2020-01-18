import 'package:flutter/material.dart';
import 'package:oversized_clock/app_theme.dart';

class Background extends StatefulWidget {
  const Background();

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = AppTheme.forContext(context);

    return Container(
        decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.9],
          colors: theme.backgroundColors),
    ));
  }
}
