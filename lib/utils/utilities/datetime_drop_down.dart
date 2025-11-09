import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:otper_mobile/app_bloc_cubit/date_time_drop_down_cubit.dart';

class DateTimeDropdownItemModel {
  final String display;
  final bool isDatePicker;
  final bool isTimePicker;
  final DateTime? Function(DateTime current)? getDateTime;

  DateTimeDropdownItemModel({
    required this.display,
    this.isDatePicker = false,
    this.isTimePicker = false,
    this.getDateTime,
  });
}

class DateTimeDropdown extends StatelessWidget {
  final List<DateTimeDropdownItemModel> items;
  final String hintText;
  final bool isDatePicker;
  final DateTime initialDateTime;


  const DateTimeDropdown({super.key, required this.items, this.hintText = "Select", required this.isDatePicker, required this.initialDateTime});

  Future<DateTime?> _pickDate(BuildContext context, DateTime current) async {
    DateTime selectedDate = current;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          onDateChanged: (date) {
            selectedDate = date;
          },
        );
      },
    );
    return selectedDate;
  }

  Future<TimeOfDay?> _pickTime(BuildContext context, TimeOfDay initialTime) async {
    return await showDialog<TimeOfDay>(
    context: context,
    builder: (context) {
      return Center(
        child: SizedBox(
          // width: 400,
          height: 500,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  hourMinuteTextStyle: Theme.of(context).textTheme.titleLarge,
                  dialTextStyle: Theme.of(context).textTheme.labelLarge,
                  dialTextColor: Colors.black,
                  dialBackgroundColor: Colors.blue.withAlpha(50),
                  ),
                ),
              child: TimePickerDialog(
                initialTime: initialTime,
                initialEntryMode: TimePickerEntryMode.dial,
              ),
            ),
          ),
        ),
      );
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateTimeDropdownCubit, DateTimeDropdownState>(
      builder: (context, state) {
        final cubit = context.read<DateTimeDropdownCubit>();
        final current = state.selectedDateTime ?? initialDateTime;

        return DropdownButton2<DateTimeDropdownItemModel>(
          hint: Text(
            isDatePicker
                ? DateFormat("dd MMM").format(current)
                : DateFormat("hh:mm a").format(current),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          buttonStyleData: ButtonStyleData(
            height: 40, 
            width: 130,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            width: 140, 
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0))
            )
          ),
          underline: Container(height: 2, color: Colors.blue),
          onChanged: (DateTimeDropdownItemModel? item) async {
            if (item == null) return;

            if (item.isDatePicker) {
              final pickedDate = await _pickDate(context, current);
              if (pickedDate != null) {
                cubit.updateDateTime(
                  DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    current.hour,
                    current.minute,
                  ),
                );
              }
            } else if (item.isTimePicker) {
              final pickedTime = await _pickTime(
                context,
                TimeOfDay(hour: current.hour, minute: current.minute),
              );
              if (pickedTime != null) {
                cubit.updateDateTime(
                  DateTime(
                    current.year,
                    current.month,
                    current.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  ),
                );
              }
            } else if (item.getDateTime != null) {
              final dateTime = item.getDateTime!(current);
              cubit.updateDateTime(dateTime!);
            }
          },
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.display, style: Theme.of(context).textTheme.labelSmall,),
              
            );
          }).toList(),
        );
      
      },
    );
  }
}


