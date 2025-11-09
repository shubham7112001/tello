import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/quick_action_cubit.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_elements/quick_actions/quick_action_content.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_elements/quick_actions/quick_actions.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuickActionsCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          QuickActions(), // Header row
          QuickActionsContent(), // Expandable chips
        ],
      ),
    );
  }
}