import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? style;
  final EdgeInsetsGeometry padding;
  final Color? splashColor;
  final BorderRadius borderRadius;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.style,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.splashColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius, // for rounded ripple
        splashColor: splashColor ?? Theme.of(context).primaryColor.withOpacity(0.2),
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: style ?? Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}