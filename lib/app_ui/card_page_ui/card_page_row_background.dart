import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/constants/app_colors.dart';

class CardPageRowBackground extends StatelessWidget {
  final Widget child;
  const CardPageRowBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.cardPageElementDark : AppColors.cardPageElementLight,
      child: child,
    );
  }
}