import 'package:flutter/material.dart';

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
    return Container(
        decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [
            0.1,
            0.9
          ],
          colors: [
            Color.fromRGBO(0x96, 0xde, 0xda, 1),
            Color.fromRGBO(0x50, 0xc9, 0xc3, 1)
          ]),
    ));
  }
}
