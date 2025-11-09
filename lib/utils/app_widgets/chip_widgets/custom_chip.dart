import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/constants/app_colors.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class CustomChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconBgColor;

  const CustomChip({
    super.key,
    required this.icon,
    required this.label, this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth / 2 - 16, // half screen, minus spacing
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.appMainSoftColor.withAlpha(100)
        ),
        child: Opacity(
          opacity: 0.8,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MediumIcon(
                icon,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
