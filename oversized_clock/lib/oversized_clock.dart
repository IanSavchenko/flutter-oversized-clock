import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:oversized_clock/background.dart';
import 'package:oversized_clock/floating_container.dart';
import 'package:oversized_clock/watchface.dart';

class OversizedClock extends StatefulWidget {
  const OversizedClock(this.model);

  final ClockModel model;

  @override
  _OversizedClockState createState() => _OversizedClockState();
}

class _OversizedClockState extends State<OversizedClock> {
  @override
  void initState() {
    super.initState();

    widget.model.addListener(_updateModel);
    _updateModel();
  }

  @override
  void didUpdateWidget(OversizedClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingContainer(
        scale: 3,
        child: Stack(
          children: <Widget>[Background(), Watchface(widget.model)],
        ));
  }
}
