import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:otper_mobile/app_bloc_cubit/date_time_drop_down_cubit.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_row_background.dart';
import 'package:otper_mobile/utils/app_widgets/dialog_widgets/datetime_dropdown_dialog.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class CardDateTime extends StatelessWidget {
  const CardDateTime({super.key, required this.startDate, required this.dueDate});

  final DateTime? startDate;
  final DateTime? dueDate;



  @override
  Widget build(BuildContext context) {
    return CardPageRowBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: MediumIcon(Icons.watch_later_outlined),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  BlocProvider(
                    create: (_) => DateTimeDropdownCubit(initialDateTime: startDate),
                    child: BlocBuilder<DateTimeDropdownCubit, DateTimeDropdownState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            HelperFunction.showCustomDialog(
                              context: context,
                              child: BlocProvider.value(
                                value: context.read<DateTimeDropdownCubit>(),
                                child: DateTimeDropDownDialog(
                                  text: "Start Time",
                                  intialTime: state.selectedDateTime,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              state.selectedDateTime == null ? "Start Date : --" : 
                              "Starts ${HelperFunction.formatToReadableDateTime(state.selectedDateTime)}",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 16, thickness: 1),

                  BlocProvider(
                    create: (_) => DateTimeDropdownCubit(initialDateTime: dueDate),
                    child: BlocBuilder<DateTimeDropdownCubit, DateTimeDropdownState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            HelperFunction.showCustomDialog(
                              context: context,
                              child: BlocProvider.value(
                                value: context.read<DateTimeDropdownCubit>(),
                                child: DateTimeDropDownDialog(
                                  text: "Due Date",
                                  intialTime: state.selectedDateTime,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              state.selectedDateTime == null ? "Due Date : --" :
                              "Due ${HelperFunction.formatToReadableDateTime(state.selectedDateTime)}",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
