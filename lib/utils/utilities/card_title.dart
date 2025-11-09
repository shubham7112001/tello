import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool isTitleLarge;

  

  const TitleRow({
    super.key,
    required this.title,
    this.onTap,
    this.padding = const EdgeInsets.all(8),
    this.isTitleLarge = false
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        // InkWell(
        //   onTap: onTap,
        //   borderRadius: BorderRadius.circular(3),
        //   child: Container(
        //     width: isTitleLarge ? 15 : 10,
        //     height: isTitleLarge ? 15 : 10,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       border: Border.all(
        //         color: borderColor,
        //         width: 1,
        //       ),
        //     ),
        //     child: isTitleLarge ? const SmallIcon(Icons.check) : const VerySmallIcon(Icons.check),
        //   ),
        // ),
        // const SizedBox(width: 4),
        Expanded(
          child: Text(
            title,
            // style: isTitleLarge ? AppTextStyles.titleSmallDark : AppTextStyles.labelLargeDark,
            style: isTitleLarge ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.labelSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
