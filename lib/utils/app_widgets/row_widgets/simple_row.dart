import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/constants/app_colors.dart';

class SimpleRowView extends StatelessWidget {
  const SimpleRowView({super.key, this.icon, required this.text, this.actions});
  final IconData? icon;
  final String text;
  final List<Widget>? actions;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if(icon != null)MediumIcon(icon!),
                if(icon != null) SizedBox(width: 8,),
                Text(text, style: Theme.of(context).textTheme.labelSmall,)
              ],
            ),
            // const Spacer(),
            if (actions != null)
              Row(
                children: actions!,
              ),
          ],
        ),
      ),
    );
  }
}
