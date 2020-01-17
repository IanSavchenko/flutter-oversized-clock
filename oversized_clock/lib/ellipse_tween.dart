import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

// Lissajous Ellipse
// based on https://www.desmos.com/calculator/1gwixpvfn8
class EllipseTween extends Animatable<Vector2> {
  EllipseTween(
      {@required this.begin,
      @required this.end,
      @required this.xParam,
      @required this.yParam,
      this.clockwise = true}) {
    _width = end.x - begin.x;
    _height = end.y - begin.y;
    _paramTween = Tween(begin: -pi, end: pi);
  }

  final Vector2 begin;
  final Vector2 end;
  final xParam;
  final yParam;
  final clockwise;

  Tween<double> _paramTween;

  double _width;
  double _height;

  @override
  Vector2 transform(double t) {
    t = _paramTween.transform(t);

    if (!this.clockwise) {
      t = -t;
    }

    var x = (_width / 2) * (1 + cos(t + this.xParam));
    var y = (_height / 2) * (1 + sin(t + this.yParam));

    return Vector2(x, y);
  }

  @override
  String toString() =>
      '$runtimeType(begin: $begin, end: $end, _width: $_width, _height: $_height)';
}
