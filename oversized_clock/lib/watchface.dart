// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oversized_clock/floating_container.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

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
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour = '06';
    // DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = '05';
    // DateFormat('mm').format(_dateTime);
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'AdventPro', // DolceVitaLight vertigup AdventPro
      fontWeight: FontWeight.w100,
      height: 1,
      fontSize: 1000,
      // shadows: [
      //   Shadow(
      //     blurRadius: 3,
      //     color: colors[_Element.shadow],
      //     offset: Offset(0, 0),
      //   ),
      // ],
    );

    final weatherText = ' '; //'Mountain View 10°C';
    final dateText = ' '; //'Thursday, December 31';

    final hourMinuteFlex = 8;
    final smallTextFlex = 1;
    final gapFlex = 1;

    return Container(
      padding: EdgeInsets.all(20),
      // child: DefaultTextStyle(style: defaultStyle, child: Text(text))
      child: DefaultTextStyle(
          style: defaultStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: hourMinuteFlex,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child:
                                Text(hour, style: TextStyle(fontSize: 10000))),
                      ),
                      Expanded(
                          flex: smallTextFlex,
                          child: FittedBox(
                              fit: BoxFit.scaleDown, child: Text(weatherText))),
                      Expanded(flex: gapFlex, child: Text('')),
                    ],
                  )),
              Expanded(flex: 0, child: Container(width: 50, child: Text(''))),
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(flex: gapFlex, child: Text('')),
                      Expanded(
                        flex: smallTextFlex,
                        child: FittedBox(
                            fit: BoxFit.scaleDown, child: Text(dateText)),
                      ),
                      Expanded(
                        flex: hourMinuteFlex,
                        child: FittedBox(
                            alignment: Alignment.bottomCenter,
                            fit: BoxFit.scaleDown,
                            child: ClipRect(
                                clipper: _CustomRect(),
                                child: Text(minute,
                                    style: TextStyle(fontSize: 10000)))),
                      )
                    ],
                  ))
            ],
          )

          // child: Stack(
          //   children: <Widget>[
          //     FittedBox(fit: BoxFit.fitHeight, child: Text(hour)),
          //     // Positioned(left: 20, top: offset, child: Text(hour)),
          //     // Positioned(right: 20, bottom: offset, child: Text(minute))
          //   ],
          // ),
          ),
    );
  }
}

class _CustomRect extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, size.height * 0.05, size.width, size.height * 0.8);
  }

  @override
  bool shouldReclip(_CustomRect oldClipper) {
    return true;
  }
}
