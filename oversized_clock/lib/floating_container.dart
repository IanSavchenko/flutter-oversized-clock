import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'ellipse_tween.dart';

class FloatingContainer extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Vector2 ellipseParams;
  final GlobalKey _rootWidgetKey = GlobalKey(); // used for getting widget size

  FloatingContainer(
      {Key key,
      @required this.child,
      @required double scale,
      @required this.duration,
      @required this.ellipseParams})
      : scale = scale.clamp(1, double.nan),
        super(key: key);

  @override
  _FloatingContainerState createState() => _FloatingContainerState();
}

class _FloatingContainerState extends State<FloatingContainer>
    with TickerProviderStateMixin {
  Animation<Vector2> _animation;
  AnimationController _controller;

  void _initAnimationController() {
    if (_controller != null) {
      _controller.dispose();
    }

    _controller =
        AnimationController(duration: this.widget.duration, vsync: this);

    // if the cycle is by minute, trying to synchronize animation with current second
    if (_controller.duration.inSeconds % 60 == 0) {
      _controller.value = DateTime.now().second / 59;
    }

    _controller.repeat();
  }

  Rect _getWidgetRect() {
    return this
        .widget
        ._rootWidgetKey
        .currentContext
        .findRenderObject()
        .paintBounds;
  }

  EllipseTween _getEllipseTween(Rect rect) {
    final scale = this.widget.scale;
    final begin = Vector2.zero();
    final end = Vector2((rect.width - rect.width / scale) * scale,
        (rect.height - rect.height / scale) * scale);

    final tween = EllipseTween(
        begin: begin,
        end: end,
        xParam: this.widget.ellipseParams.x,
        yParam: this.widget.ellipseParams.y);

    return tween;
  }

  void _updateAnimation() {
    // this func must be run after the first frame was rendered
    // this makes it possible to get widget rect,
    // so we can start "translating" it
    //
    // all this is because of translation transformation
    // requiring absolute values in logical pixels
    //
    // this code has to be rerun when size of this widget (FloatingContainer) changes

    final widgetRect = _getWidgetRect();
    final ellipseTween = _getEllipseTween(widgetRect);

    _animation = ellipseTween.animate(_controller);
    SchedulerBinding.instance.addPostFrameCallback((_renderDuration) {
      // postFrameCallback is a safer place to do this,
      // because setState() may end up with an error on widget resize notification
      setState(() => {}); // to start using new animation
    });
  }

  bool _onSizeChangedNotification(_notification) {
    _updateAnimation();
    return true;
  }

  @override
  void initState() {
    super.initState();
    _initAnimationController();

    SchedulerBinding.instance.addPostFrameCallback((_renderDuration) {
      // init animations only after first render
      _updateAnimation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rotationQ = Quaternion.identity();
    final scaleV3 = Vector3(this.widget.scale, this.widget.scale, 1);

    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: _onSizeChangedNotification,
      child: SizeChangedLayoutNotifier(
          child: ClipRect(
              key: this.widget._rootWidgetKey,
              child: AnimatedBuilder(
                animation: _controller,
                child: this.widget.child,
                builder: (_, preBuiltChild) {
                  final translateV3 = _animation == null // first frame case
                      ? Vector3.zero()
                      : Vector3(-_animation.value.x, -_animation.value.y, 0);
                  final transformM4 =
                      Matrix4.compose(translateV3, rotationQ, scaleV3);
                  return Container(
                      transform: transformM4, child: preBuiltChild);
                },
              ))),
    );
  }
}
