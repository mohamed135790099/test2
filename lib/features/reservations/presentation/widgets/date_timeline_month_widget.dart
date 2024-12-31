import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:flutter/material.dart';

class DateTimelineMonth extends StatefulWidget {
  const DateTimelineMonth({super.key});

  @override
  State<DateTimelineMonth> createState() => _DateTimelineMonthState();
}

class _DateTimelineMonthState extends State<DateTimelineMonth> {
  late DateTime _selectedMonth; // Holds the selected month

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Replace with your dropdown or selection mechanism
        DropdownButton<int>(
          value: _selectedMonth.month,
          items: List.generate(12, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text(_getMonthName(
                  index + 1)), // Example function to get month name
            );
          }),
          onChanged: (int? newMonth) {
            if (newMonth != null) {
              setState(() {
                _selectedMonth =
                    DateTime(_selectedMonth.year, newMonth, _selectedMonth.day);
              });

              // Trigger onDateChange directly with the new month
              _handleDateChange(
                  DateTime(_selectedMonth.year, newMonth, _selectedMonth.day));
            }
          },
        ),
      ],
    );
  }

  void _handleDateChange(DateTime newDate) {
    // Handle date change logic here
    print('Selected Date: $newDate');
    // Example of using a Cubit/Bloc to update state based on new date
    ReservationCubit.get(context).setMonth(newDate);
  }

  String _getMonthName(int monthNumber) {
    // Replace with your own logic to get month names
    switch (monthNumber) {
      case 1:
        return 'يناير';
      case 2:
        return 'فبراير';
      case 3:
        return 'مارس';
      case 4:
        return 'أبريل';
      case 5:
        return 'مايو';
      case 6:
        return 'يونيو';
      case 7:
        return 'يوليو';
      case 8:
        return 'أغسطس';
      case 9:
        return 'سبتمبر';
      case 10:
        return 'أكتوبر';
      case 11:
        return 'نوفمبر';
      case 12:
        return 'ديسمبر';
      default:
        return '';
    }
  }
}
