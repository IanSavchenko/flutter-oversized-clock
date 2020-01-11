import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class FloatingContainer extends StatefulWidget {
  FloatingContainer({Key key, @required this.child, @required this.scale})
      : super(key: key);

  final Widget child;
  final double scale;
  final GlobalKey _rootWidgetKey = GlobalKey();

  @override
  _FloatingContainerState createState() => _FloatingContainerState();
}

class _FloatingContainerState extends State<FloatingContainer>
    with TickerProviderStateMixin {
  Animation<Vector2> _translateAnimation;
  AnimationController _translateController;

  final Duration _translateDuration = const Duration(seconds: 40);

  void _initTranslateAnimation() {
    final renderBox =
        this.widget._rootWidgetKey.currentContext.findRenderObject();
    final widgetSize = renderBox.paintBounds;
    final scale = widget.scale.clamp(1, double.infinity);
    final endVector2 = Vector2(
        (widgetSize.width - widgetSize.width / scale) * scale,
        (widgetSize.height - widgetSize.height / scale) * scale);

    if (_translateController != null) {
      _translateController.dispose();
    }

    _translateController = AnimationController(
        duration: _translateDuration,
        vsync: this,
        reverseDuration: _translateDuration);

    _translateAnimation =
        _TranslateVector2EllipseTween(begin: Vector2.zero(), end: endVector2)
            .animate(_translateController)
              ..addListener(() {
                setState(() {
                  // The state that has changed here is the animation object’s value.
                });
              })
              ..addStatusListener((status) {
                // going back and forth
                // if (status == AnimationStatus.completed) {
                //   _translateController.reverse();
                // }

                // if (status == AnimationStatus.dismissed) {
                //   _translateController.forward();
                // }
              });

    // starting animation
    _translateController.repeat();
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_duration) {
      // start animations only after first render to get widget size
      _initTranslateAnimation();
    });
  }

  @override
  void dispose() {
    _translateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale.clamp(1, double.infinity);

    var translateV3 = _translateAnimation != null
        ? Vector3(-_translateAnimation.value.x, -_translateAnimation.value.y, 0)
        : Vector3.zero();
    var rotationQ = Quaternion.identity();
    var scaleV3 = Vector3(scale, scale, 1);

    var transformM4 = Matrix4.compose(translateV3, rotationQ, scaleV3);

    return NotificationListener<SizeChangedLayoutNotification>(
      child: SizeChangedLayoutNotifier(
          child: ClipRect(
              key: this.widget._rootWidgetKey,
              child: Container(transform: transformM4, child: widget.child))),
      onNotification: (_notification) {
        _initTranslateAnimation();
        return true;
      },
    );
  }
}

class _TranslateVector2Tween extends Animatable<Vector2> {
  _TranslateVector2Tween({Vector2 this.begin, Vector2 this.end}) {
    xTween = Tween(begin: begin.x, end: end.x)
        .chain(CurveTween(curve: Curves.linear));
    yTween = Tween(begin: begin.y, end: end.y)
        .chain(CurveTween(curve: Curves.easeInCubic));
  }

  final Vector2 begin;
  final Vector2 end;
  Animatable<double> xTween;
  Animatable<double> yTween;

  @override
  Vector2 transform(double t) {
    return Vector2(xTween.transform(t), yTween.transform(t));
  }

  @override
  String toString() =>
      '$runtimeType(begin: $begin, end: $end, xTween: $xTween, yTween: $yTween)';
}

// https://www.desmos.com/calculator/1gwixpvfn8
class _TranslateVector2EllipseTween extends Animatable<Vector2> {
  _TranslateVector2EllipseTween({Vector2 this.begin, Vector2 this.end}) {
    width = end.x - begin.x;
    height = end.y - begin.y;
    paramTween = Tween(begin: -pi, end: pi);
  }

  final Vector2 begin;
  final Vector2 end;

  final u = 0.3;
  final v = 0;

  Tween<double> paramTween;

  double width;
  double height;

  @override
  Vector2 transform(double t) {
    t = -paramTween.transform(t); // minus changes the direction of rotation

    var x = (width / 2) * (1 + sin(t + u));
    var y = (height / 2) * (1 + cos(t + v));

    return Vector2(x, y);
  }

  @override
  String toString() =>
      '$runtimeType(begin: $begin, end: $end, width: $width, height: $height)';
}
