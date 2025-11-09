import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/quick_action_cubit.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuickActionsCubit, bool>(
      builder: (context, expanded) {
        return InkWell(
          onTap: () => context.read<QuickActionsCubit>().toggle(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quick Actions",
                    style: Theme.of(context).textTheme.labelLarge),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down_outlined),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
