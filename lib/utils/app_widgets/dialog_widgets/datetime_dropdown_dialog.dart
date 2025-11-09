import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/utils/app_widgets/app_buttons/app_text_button.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';
import 'package:otper_mobile/utils/utilities/datetime_drop_down.dart';
import 'package:otper_mobile/app_bloc_cubit/date_time_drop_down_cubit.dart';

class DateTimeDropDownDialog extends StatelessWidget {
  final String text;
  final DateTime? intialTime;
  const DateTimeDropDownDialog({super.key, required this.text, required this.intialTime});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateTimeDropdownCubit, DateTimeDropdownState>(
     builder: (context, state) {
        final cubit = context.read<DateTimeDropdownCubit>();
        final current = state.selectedDateTime ?? intialTime;
    
        final dateItems = [
          DateTimeDropdownItemModel(
            display: "Today",
            getDateTime: (current) => DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              current.hour,
              current.minute,
              current.second,
            ),
          ),
          DateTimeDropdownItemModel(
            display: "Tomorrow",
            getDateTime: (current) {
              final tomorrow = DateTime.now().add(const Duration(days: 1));
              return DateTime(
                tomorrow.year,
                tomorrow.month,
                tomorrow.day,
                current.hour,
                current.minute,
                current.second,
              );
            },
          ),
          DateTimeDropdownItemModel(
            display: "Next ${HelperFunction.getTodaysDay()}",
            getDateTime: (current) {
              final nextWeek = DateTime.now().add(const Duration(days: 7));
              return DateTime(
                nextWeek.year,
                nextWeek.month,
                nextWeek.day,
                current.hour,
                current.minute,
                current.second,
              );
            },
          ),
          DateTimeDropdownItemModel(
            display: "Pick a date",
            isDatePicker: true,
          ),
        ];
    
        final timeItems = [
          DateTimeDropdownItemModel(
            display: "Morning",
            getDateTime: (current) =>
                DateTime(current.year, current.month, current.day, 9, 0),
          ),
          DateTimeDropdownItemModel(
            display: "Afternoon",
            getDateTime: (current) =>
                DateTime(current.year, current.month, current.day, 13, 0),
          ),
          DateTimeDropdownItemModel(
            display: "Evening",
            getDateTime: (current) =>
                DateTime(current.year, current.month, current.day, 16, 0),
          ),
          DateTimeDropdownItemModel(
            display: "Night",
            getDateTime: (current) =>
                DateTime(current.year, current.month, current.day, 20, 0),
          ),
          DateTimeDropdownItemModel(display: "Pick a time", isTimePicker: true),
        ];
        return Material(
          child: Center(
              child: Container(
                height: 90.h,
                width: 300.w,
                color: Theme.of(context).colorScheme.surfaceDim,
                padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(text, style: Theme.of(context).textTheme.titleSmall),
                    if(!state.isRowVisible)
                    InkWell(
                      onTap: () => cubit.showRow(),
                      child: Row(
                        spacing: 6,
                        children: [
                        MediumIcon(Icons.watch_later_outlined),
                        Text("Add ${text.toLowerCase()}")
                      ],),
                    ),
                    if(state.isRowVisible)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DateTimeDropdown(
                            items: dateItems,
                            hintText: "Select date",
                            isDatePicker: true,
                            initialDateTime: current ?? DateTime.now(),
                          ),
                          const SizedBox(width: 5),
                          DateTimeDropdown(
                            items: timeItems,
                            hintText: "Select time",
                            isDatePicker: false,
                            initialDateTime: current ?? DateTime.now(),
                          ),
                          InkWell(
                            onTap: () => cubit.hideRow(),
                            child: MediumIcon(Icons.cancel))
                        ],
                      ),
    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppTextButton(
                            text: "Cancel",
                            onTap: () {
                              AppNavigator.pop();
                            },
                          ),
                          SizedBox(width: 20,),
                          AppTextButton(
                            text: "Done",
                            onTap: () {
                               AppNavigator.pop();
                            },
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
        );
      }
    );
  }
}