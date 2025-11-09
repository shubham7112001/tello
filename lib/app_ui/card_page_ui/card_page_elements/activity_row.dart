import 'package:flutter/material.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_row_background.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/simple_row.dart';

class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key});

  @override
  Widget build(BuildContext context) {
    return CardPageRowBackground(
      child: SimpleRowView(text: "Activity",
      actions: [
          MediumIcon(Icons.more_vert)
        ],
      ),
    );
  }
}