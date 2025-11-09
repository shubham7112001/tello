import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/labels_cubit.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_row_background.dart';
import 'package:otper_mobile/data/models/card_model.dart';
import 'package:otper_mobile/utils/app_widgets/expandable_widget.dart';
import 'package:otper_mobile/utils/helper/app_extensions.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class LabelsView extends StatelessWidget {
  final List<CardLabel> labels;
  const LabelsView({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LabelsCubit(),
      child: BlocBuilder<LabelsCubit, bool>(
        builder: (context, expanded) {
          return CardPageRowBackground(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                InkWell(
                  onTap: () {
                    if (labels.isNotEmpty) {
                      context.read<LabelsCubit>().toggle();
                    }
                  },
                  child: SizedBox(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.label_outline_rounded, size: 20),
                              const SizedBox(width: 8),
                              Text("Labels",
                                  style: Theme.of(context).textTheme.labelSmall),
                            ],
                          ),
                          if (labels.isNotEmpty)
                            Icon(
                              expanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                  ExpandableWidget(
                    expand: expanded,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6),
                      child: Column(
                        children: labels.map((label) {
                          return Container(

                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: HelperFunction.parseColor(label.color ?? "") ,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    (label.name ?? "No labels").capitalizeFirst(),
                                    style: TextStyle(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
