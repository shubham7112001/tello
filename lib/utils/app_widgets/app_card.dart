

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_view.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/models/board_model.dart';
import 'package:otper_mobile/data/models/card_model.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/constants/app_colors.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';
import 'package:otper_mobile/utils/utilities/card_title.dart';

final EdgeInsets hPadding = EdgeInsets.symmetric(horizontal: 6);

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.card, required this.board});
  final BoardViewCardModel card;
  final HomeBoardModel board;
  final double spacing = 4;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigator.goToCard(slug: card.slug, title: card.title, boardId: board.id ?? ""),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.darkTextTheme
              : AppColors.lightTextTheme
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "#${board.key} ${card.cardNumber}",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TitleRow(title: card.title),
            _labelView(card.labels ?? [], context),
          ],
        ),
      ),
    );
  }
}

Widget _imageContainer() {
  return Container(
    width: 220, // slightly smaller
    height: 120, // reduced height
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
      image: DecorationImage(
        image: NetworkImage(imageLink),
        fit: BoxFit.cover,
      ),
    ),
  );
}

String imageLink =
    "https://images.pexels.com/photos/31009096/pexels-photo-31009096.jpeg";

Widget _labelView(List<CardLabel> cardLabels, BuildContext context) {
  debugPrint("Labels length: ${cardLabels.length}");
  
  return Wrap(
    spacing: 2, // horizontal space between labels
    runSpacing: 2, // vertical space if wrapped
    children: cardLabels.map((label) {
      Color labelColor = Colors.grey; // fallback color
  
      // Convert hex string to Color if available
      if (label.color != null && label.color!.isNotEmpty) {
        try {
          String hexColor = label.color!.replaceAll('#', '');
          if (hexColor.length == 6) hexColor = 'FF$hexColor';
          labelColor = Color(int.parse(hexColor, radix: 16));
        } catch (e) {
          debugPrint("Error while label listing");
        }
      }
  
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 2,
        ), // minimal padding
        decoration: BoxDecoration(
          color: labelColor,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(width: 0.2),
        ),
        child: Text(
          label.name ?? "",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: HelperFunction.getTextColor(labelColor), // <-- dynamic text color
            fontSize: 8,
            height: 1,
          ),
        ),
      );
    }).toList(),
  );
}




class _SmallChecklistRow extends StatelessWidget {
  final String text;
  final IconData icon;

  const _SmallChecklistRow({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 10,
          height: 10,
          child: Center(
            child: SmallIcon(icon), // ✅ your custom SmallIcon widget
          ),
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
Widget infoRow({
  String? date,
  String? attachments,
  String? checklistCount,
}) {
  List<Widget> children = [];
  final double spacing = 4.0;

  if (date != null || attachments != null || checklistCount != null) {
    children.add(SmallIcon(Icons.watch_later_outlined));
    children.add(SizedBox(width: spacing));
  }

  if (date != null) {
    children.add(_SmallChecklistRow(text:date, icon:Icons.date_range_outlined));
    children.add(SizedBox(width: spacing));
  }

  if (attachments != null) {
    children.add(_SmallChecklistRow(text:attachments, icon: Icons.attachment_outlined));
    children.add(SizedBox(width: spacing));
  }

  if (checklistCount != null) {
    children.add(_SmallChecklistRow(text:checklistCount, icon: Icons.check_box_outlined));
    children.add(SizedBox(width: spacing));
  }

  children.add(SmallIcon(Icons.refresh));

  return Padding(
    padding: hPadding,
    child: Row(children: children),
  );

  
}
