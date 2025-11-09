
import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {
  final bool expand;
  final Widget child;

  const ExpandableWidget({
    required this.expand,
    required this.child,
  });

  @override
  State<ExpandableWidget> createState() => ExpandableWidgetState();
}

class ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (widget.expand) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(ExpandableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _curve,
      axisAlignment: -1.0, // expand downward
      child: FadeTransition(
        opacity: _curve,
        child: widget.child,
      ),
    );
  }
}