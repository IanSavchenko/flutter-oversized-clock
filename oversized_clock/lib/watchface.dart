import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class Watchface extends StatefulWidget {
  const Watchface(this.model);

  final ClockModel model;

  @override
  _WatchfaceState createState() => _WatchfaceState();
}

class _WatchfaceState extends State<Watchface>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(Watchface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);

    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    var hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    var minute = DateFormat('mm').format(_dateTime);
    var weekDay = DateFormat('E').format(_dateTime).toUpperCase();

    // debug
    // hour = '22';
    // minute = '44';
    // weekDay = 'SU';

    final frontStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'vertigup',
      fontWeight: FontWeight.w100,
      height: 1,
      fontSize: 1650,
      // shadows: [
      //   Shadow(
      //     blurRadius: 3,
      //     color: colors[_Element.shadow],
      //     offset: Offset(0, 0),
      //   ),
      // ],
    );

    final backStyle = TextStyle(
        color: Colors.white24, fontFamily: 'vertiup2', fontSize: 3600);

    return FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
            width: 5000,
            height: 3000,
            child: DefaultTextStyle(
                style: frontStyle,
                child: Stack(
                  children: <Widget>[
                    // bottom layer: two big letters representing week day
                    // pretty-much decorative
                    Opacity(
                      opacity: 1,
                      child: DefaultTextStyle(
                        style: backStyle,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: -350,
                              left: -150,
                              child: Text(
                                weekDay[0],
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Positioned(
                              top: -350,
                              left: 3000,
                              child: Text(
                                weekDay[1],
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // front layer: two rows of numbers representing hour and minute
                    Stack(
                      children: <Widget>[
                        // top row
                        Positioned(
                          top: -50,
                          left: 300,
                          width: 1200,
                          child: Text(
                            hour[0],
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Positioned(
                          top: -50,
                          left: 1450,
                          width: 1200,
                          child: Text(
                            hour[1],
                            textAlign: TextAlign.left,
                          ),
                        ),

                        // second row
                        Positioned(
                          bottom: -50,
                          left: 2300,
                          width: 1200,
                          child: Text(minute[0], textAlign: TextAlign.right),
                        ),

                        Positioned(
                          bottom: -50,
                          left: 3450,
                          width: 1200,
                          child: Text(minute[1], textAlign: TextAlign.left),
                        ),
                      ],
                    )
                  ],
                ))));
  }
}
