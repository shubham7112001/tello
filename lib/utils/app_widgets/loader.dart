import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Extension for easier AnimationController evaluation
extension LoadingAnimationControllerX on AnimationController {
  T eval<T>(Tween<T> tween, {Curve curve = Curves.linear}) =>
      tween.transform(curve.transform(value));

  double evalDouble({
    double from = 0,
    double to = 1,
    double begin = 0,
    double end = 1,
    Curve curve = Curves.linear,
  }) {
    return eval(
      Tween<double>(begin: from, end: to),
      curve: Interval(begin, end, curve: curve),
    );
  }
}

/// The main DotsTriangle widget
class Loader extends StatefulWidget {
  final double? size;
  final Color? color;

  const Loader({Key? key, this.size, this.color}) : super(key: key);

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size ?? 50.0;
    final Color color = widget.color ?? Colors.blue;
    final double dotDepth = size / 8;
    final double dotLength = size / 2;
    const Interval interval = Interval(0.0, 0.8);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) => SizedBox(
        width: size,
        height: size,
        child: Center(
          child: SizedBox(
            width: size,
            height: 0.884 * size,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: BuildSides.forward(
                    rotationAngle: 2 * math.pi / 3,
                    rotationOrigin: Offset(-(size - dotDepth) / 2, 0),
                    maxLength: dotLength,
                    depth: dotDepth,
                    color: color,
                    controller: _animationController,
                    interval: interval,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BuildSides.reverse(
                    rotationAngle: math.pi / 3,
                    rotationOrigin: Offset((size - dotDepth) / 2, 0),
                    maxLength: dotLength,
                    depth: dotDepth,
                    color: color,
                    controller: _animationController,
                    interval: interval,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BuildSides.forward(
                    maxLength: dotLength,
                    depth: dotDepth,
                    color: color,
                    controller: _animationController,
                    interval: interval,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// Internal widget that builds each moving side
class BuildSides extends StatelessWidget {
  final double maxLength;
  final double depth;
  final Color color;
  final AnimationController controller;
  final Interval interval;
  final double rotationAngle;
  final Offset rotationOrigin;
  final bool forward;

  const BuildSides.forward({
    Key? key,
    required this.maxLength,
    required this.depth,
    required this.color,
    required this.controller,
    required this.interval,
    this.rotationAngle = 0,
    this.rotationOrigin = Offset.zero,
  })  : forward = true,
        super(key: key);

  const BuildSides.reverse({
    Key? key,
    required this.maxLength,
    required this.depth,
    required this.color,
    required this.controller,
    required this.interval,
    this.rotationAngle = 0,
    this.rotationOrigin = Offset.zero,
  })  : forward = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double offset = maxLength / 2;
    final double startInterval = interval.begin;
    final double middleInterval = (interval.begin + interval.end) / 2;
    final double endInterval = interval.end;

    final Interval leftInterval = Interval(startInterval, middleInterval);
    final Interval rightInterval = Interval(middleInterval, endInterval);

    final Widget firstChild = Visibility(
      visible: forward
          ? controller.value <= middleInterval
          : controller.value >= middleInterval,
      child: Transform.translate(
        offset: controller.eval(
          Tween<Offset>(
            begin: forward ? Offset.zero : Offset(offset, 0),
            end: forward ? Offset(offset, 0) : Offset.zero,
          ),
          curve: forward ? leftInterval : rightInterval,
        ),
        child: RoundedRectangle.horizontal(
          width: controller.eval(
            Tween<double>(
              begin: forward ? depth : maxLength,
              end: forward ? maxLength : depth,
            ),
            curve: forward ? leftInterval : rightInterval,
          ),
          height: depth,
          color: color,
        ),
      ),
    );

    final Widget secondChild = Visibility(
      visible: forward
          ? controller.value >= middleInterval
          : controller.value <= middleInterval,
      child: Transform.translate(
        offset: controller.eval(
          Tween<Offset>(
            begin: forward ? Offset(-offset, 0) : Offset.zero,
            end: forward ? Offset.zero : Offset(-offset, 0),
          ),
          curve: forward ? rightInterval : leftInterval,
        ),
        child: RoundedRectangle.horizontal(
          width: controller.eval(
            Tween<double>(
              begin: forward ? maxLength : depth,
              end: forward ? depth : maxLength,
            ),
            curve: forward ? rightInterval : leftInterval,
          ),
          height: depth,
          color: color,
        ),
      ),
    );

    return Transform.rotate(
      angle: rotationAngle,
      origin: rotationOrigin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [firstChild, secondChild],
      ),
    );
  }
}

/// Rounded rectangle helper
class RoundedRectangle extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final bool vertical;

  const RoundedRectangle.vertical({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
  })  : vertical = true,
        super(key: key);

  const RoundedRectangle.horizontal({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
  })  : vertical = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(vertical ? width : height),
      ),
    );
  }
}
