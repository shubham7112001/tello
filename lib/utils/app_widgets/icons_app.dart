import 'package:flutter/material.dart';

enum IconSize { verySmall, small, medium, mediumLarge, large, extraLarge }

class AppIconWidget extends StatelessWidget {
  final IconData icon;
  final IconSize size;
  final Color? color;

  const AppIconWidget({
    required this.icon,
    this.size = IconSize.medium,
    this.color,
    super.key,
  });

  double get _iconSize {
    switch (size) {
      case IconSize.verySmall:
        return 8.0;
      case IconSize.small:
        return 12.0;
      case IconSize.medium:
        return 16.0;
      case IconSize.mediumLarge:
        return 20.0;
      case IconSize.large:
        return 24.0;
      case IconSize.extraLarge:
        return 32.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: _iconSize,
      color: color,
    );
  }
}

class VerySmallIcon extends AppIconWidget {
  const VerySmallIcon(
    IconData icon, {
    super.key,
    super.color,
  }) : super(
          icon: icon,
          size: IconSize.verySmall,
        );
}

class SmallIcon extends AppIconWidget {
  const SmallIcon(
    IconData icon, {
    super.key,
    super.color,
  }) : super(
          icon: icon,
          size: IconSize.small,
        );
}

class MediumIcon extends AppIconWidget {
  const MediumIcon(
    IconData icon, {
    super.key,
    super.color,
  }) : super(
          icon: icon,
          size: IconSize.medium,
        );
}

class MediumLargeIcon extends AppIconWidget {
  const MediumLargeIcon(
    IconData icon, {
    super.key,
    super.color,
  }) : super(
          icon: icon,
          size: IconSize.mediumLarge,
        );
}

class LargeIcon extends AppIconWidget {
  const LargeIcon(
    IconData icon, {
    super.key,
    super.color,
  }) : super(
          icon: icon,
          size: IconSize.large,
        );
}

class ExtraLargeIcon extends AppIconWidget {
  const ExtraLargeIcon(
    IconData icon, {
    super.key,
    super.color,
  }) : super(
          icon: icon,
          size: IconSize.extraLarge,
        );
}

class AnimatedRotatedWidget extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final Duration duration;

  const AnimatedRotatedWidget({
    super.key,
    required this.child,
    this.isExpanded = false,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isExpanded ? 0.5 : 0,
      duration: duration,
      child: child,
    );
  }
}
