import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/checklist_blocs/checklist_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/checklist_blocs/checklist_state.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_row_background.dart';
import 'package:otper_mobile/utils/app_widgets/app_text_field.dart';
import 'package:otper_mobile/utils/app_widgets/expandable_widget.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/simple_row.dart';

class ChecklistView extends StatelessWidget {
  const ChecklistView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistCubit, ChecklistState>(
      builder: (context, state) {
        log("Focused Checklist index: ${state.focusedChecklistIndex}");
        
        return CardPageRowBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MAIN HEADER
              Row(
                children: [
                  InkWell(
                    onTap: () => context.read<ChecklistCubit>().toggleMainExpand(),
                    child: SimpleRowView(
                      icon: Icons.check_box_outlined, 
                      text: "Checklists", 
                      actions: [
                          AnimatedRotatedWidget(
                            isExpanded: state.isExpanded,
                            child: Icon(Icons.keyboard_arrow_down)
                            ),
                      ],
                    ),
                  ),
                    
                ],
              ),
              
              
              ExpandableWidget(
                expand: state.isExpanded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...state.checklists.asMap().entries.map((entry) {
                    final index = entry.key;
                    final checklist = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => context
                              .read<ChecklistCubit>()
                              .toggleChecklistExpand(index),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16,right: 8),
                            child: Row(
                              children: [
                                Text(checklist.title ?? "No", style: Theme.of(context).textTheme.labelSmall,),
                                const Spacer(),
                                AnimatedRotatedWidget(
                                  isExpanded: state.focusedChecklistIndex != null &&  state.focusedChecklistIndex == index,
                                  child: Icon(Icons.keyboard_arrow_down)
                                ),
                              ],
                            ),
                          ),
                        ),
              
                        ExpandableWidget(
                          expand: state.focusedChecklistIndex != null &&  state.focusedChecklistIndex == index,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24, top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...(checklist.checkpoints ?? []).asMap().entries.map((entry) {
                                  final itemIndex = entry.key;
                                  final item = entry.value;

                                  return InkWell(
                                    onTap: () => context.read<ChecklistCubit>().toggleChecklistItemStatus(index, itemIndex),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Row(
                                        children: [
                                          MediumIcon(
                                            item.status == true
                                              ? Icons.check_box_outlined
                                              : Icons.check_box_outline_blank_sharp,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            item.title ?? "No title",
                                            style: Theme.of(context).textTheme.labelSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),

                                  Container(
                                    height: 30,
                                    margin: const EdgeInsets.only(top: 6),
                                    child: AppTextField(
                                      focusNode: state.itemFocusNodes[index],
                                      keepFocusOnSubmit: true,
                                      minLines: 1,
                                      maxLines: 1,
                                      hint: "Add item...",
                                      onSubmitted: (value) {
                                        context.read<ChecklistCubit>().addChecklistItem(
                                          index,
                                          value, // title
                                          checklist.checkpoints?.length ?? 0, // pos
                                        );
                                      },
                                    ),
                                  ),
                              ]
              
                            ),
                          ),
                        ),
                        
                      ],
                    );
                  }),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: AppTextField(
                      focusNode: state.addChecklistFocusNode,
                      hint: "Add checklist",
                      keepFocusOnSubmit: true,
                      minLines: 1,
                      maxLines: 1,
                      onSubmitted: (value) {
                        log("Value: $value");
                          context.read<ChecklistCubit>().addChecklist(
                            value,
                            state.checklists.length,
                          );
                        },
                    
                    ),
                  ) 
            ]
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

