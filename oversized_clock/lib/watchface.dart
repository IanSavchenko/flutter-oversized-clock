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
      // Update once per minute. If you want to update every second, use the
      // following code.
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
    final hour = // '22';
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = // '22';
        DateFormat('mm').format(_dateTime);

    final day = DateFormat('E').format(_dateTime);

    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'vertigup', // DolceVitaLight vertigup AdventPro
      fontWeight: FontWeight.w100,
      height: 1,
      fontSize: 1400,
      // shadows: [
      //   Shadow(
      //     blurRadius: 3,
      //     color: colors[_Element.shadow],
      //     offset: Offset(0, 0),
      //   ),
      // ],
    );

    return FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
            width: 5000,
            height: 3000,
            child: DefaultTextStyle(
                style: defaultStyle,
                child: Stack(
                  children: <Widget>[
                    ///////
                    Positioned(
                      top: -30,
                      left: 100,
                      width: 2500,
                      child: Text(day[0],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 3075,
                              color: Colors.white12,
                              fontFamily: 'vertiup2')),
                    ),
                    /////
                    Positioned(
                      top: -30,
                      left: 2450,
                      width: 2500,
                      child: Text(day[1],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 3075,
                              color: Colors.white12,
                              fontFamily: 'vertiup2')),
                    ),

                    // Positioned(
                    //   bottom: 1500,
                    //   left: 2500,
                    //   width: 1200,
                    //   child: Text('e',
                    //       textAlign: TextAlign.left,
                    //       style: TextStyle(
                    //           color: Colors.white12, fontFamily: 'vertiup2')),
                    // ),

                    // Positioned(
                    //   bottom: 1500,
                    //   left: 3700,
                    //   width: 1200,
                    //   child: Text('r',
                    //       textAlign: TextAlign.left,
                    //       style: TextStyle(
                    //           color: Colors.white12, fontFamily: 'vertiup2')),
                    // ),

                    // Positioned(
                    //   bottom: 100,
                    //   left: 100,
                    //   width: 1200,
                    //   child: Text('f',
                    //       textAlign: TextAlign.left,
                    //       style: TextStyle(
                    //           color: Colors.white12, fontFamily: 'vertiup2')),
                    // ),
                    // /////
                    // Positioned(
                    //   bottom: 100,
                    //   left: 1300,
                    //   width: 1200,
                    //   child: Text('l',
                    //       textAlign: TextAlign.left,
                    //       style: TextStyle(
                    //           color: Colors.white12, fontFamily: 'vertiup2')),
                    // ),

                    // Positioned(
                    //   bottom: -300,
                    //   left: 2550,
                    //   width: 1200,
                    //   child: Text(minute[0],
                    //       textAlign: TextAlign.right,
                    //       style: TextStyle(
                    //           fontSize: 2100,
                    //           color: Colors.white12,
                    //           fontFamily: 'vertiup2')),
                    // ),

                    // Positioned(
                    //   bottom: -300,
                    //   left: 3700,
                    //   width: 1200,
                    //   child: Text(minute[1],
                    //       textAlign: TextAlign.left,
                    //       style: TextStyle(
                    //           fontSize: 2100,
                    //           color: Colors.white12,
                    //           fontFamily: 'vertiup2')),
                    // ),

                    ///
                    /// first row
                    Positioned(
                      top: 100,
                      left: 150,
                      width: 1200,
                      child: Text(
                        hour[0],
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 1300,
                      width: 1200,
                      child: Text(
                        hour[1],
                        textAlign: TextAlign.left,
                      ),
                    ),

                    // second row
                    Positioned(
                      bottom: 100,
                      left: 2550,
                      width: 1200,
                      child: Text(minute[0], textAlign: TextAlign.right),
                    ),

                    Positioned(
                      bottom: 100,
                      left: 3700,
                      width: 1200,
                      child: Text(minute[1], textAlign: TextAlign.left),
                    ),
                  ],
                ))));
  }
}
