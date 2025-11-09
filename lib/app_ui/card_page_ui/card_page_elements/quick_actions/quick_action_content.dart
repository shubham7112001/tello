import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/members_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/quick_action_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/checklist_blocs/checklist_cubit.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_elements/members_view.dart';
import 'package:otper_mobile/utils/app_widgets/chip_widgets/custom_chip.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/add_attachment_row.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class QuickActionsContent extends StatelessWidget {
  const QuickActionsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuickActionsCubit, bool>(
      builder: (context, expanded) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topRight,
          child: expanded
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      InkWell(
                        onTap: () => context.read<ChecklistCubit>().toggleMainExpand(),
                        child: const CustomChip(icon: Icons.check_box_outlined, label: "Add Checklist"),
                      ),

                      InkWell(
                        onTap: () => showAttachmentOptions(context),
                        child: const CustomChip(icon: Icons.attachment, label: "Add attachment"),
                      ),

                      InkWell(
                        onTap: () {
                          // Open Members dialog
                          HelperFunction.showCustomDialog(
                            context: context,
                            child: BlocProvider.value(
                              value: context.read<MembersCubit>(), // pass existing cubit
                              child: const MembersView(),
                            ),
                            useIntrinsic: false,
                          );
                        },
                        child: const CustomChip(icon: Icons.person_2_outlined, label: "Members"),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}