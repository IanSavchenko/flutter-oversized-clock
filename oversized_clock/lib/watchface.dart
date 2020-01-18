import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oversized_clock/app_theme.dart';

class Watchface extends StatefulWidget {
  const Watchface(this.model);

  final ClockModel model;

  @override
  _WatchfaceState createState() => _WatchfaceState();
}

class _WatchfaceState extends State<Watchface>
    with SingleTickerProviderStateMixin {
  DateTime _now = DateTime.now();
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
      _now = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _now.second) -
            Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.forContext(context);

    var hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_now);
    var minute = DateFormat('mm').format(_now);
    var weekDay = DateFormat('E').format(_now).toUpperCase();
    var frontSemanticsValue =
        DateFormat(widget.model.is24HourFormat ? 'Hm' : 'jm').format(_now);

    // debug
    // hour = '22';
    // minute = '44';
    // weekDay = 'SU';

    final frontTextStyle = TextStyle(
        color: theme.frontTextColor,
        fontFamily: 'vertigup',
        height: 1,
        fontSize: 1650);

    final backTextStyle = TextStyle(
        color: theme.backTextColor, fontFamily: 'vertiup2', fontSize: 3600);

    return FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
            width: 5000,
            height: 3000,
            child: Stack(children: <Widget>[
              // bottom layer: two big letters representing week day
              // pretty-much decorative
              DefaultTextStyle(
                style: backTextStyle,
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

              // front layer: two rows of numbers representing hour and minute
              Semantics(
                  label: 'Current time',
                  value: frontSemanticsValue,
                  container: true,
                  excludeSemantics: true,
                  child: DefaultTextStyle(
                      style: frontTextStyle,
                      child: Stack(
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
                      )))
            ])));
  }
}
