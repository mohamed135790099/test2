import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:flutter/material.dart';

class DateTimelineYear extends StatefulWidget {
  const DateTimelineYear({super.key});

  @override
  State<DateTimelineYear> createState() => _DateTimelineYearState();
}

class _DateTimelineYearState extends State<DateTimelineYear> {
  late DateTime _selectedYear; // Holds the selected year

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown for year selection
        DropdownButton<int>(
          value: _selectedYear.year,
          items: List.generate(10, (index) {
            return DropdownMenuItem<int>(
              value: DateTime.now().year - index,
              child: Text(
                  (DateTime.now().year - index).toString()), // Display year
            );
          }),
          onChanged: (int? newYear) {
            if (newYear != null) {
              setState(() {
                _selectedYear =
                    DateTime(newYear, _selectedYear.month, _selectedYear.day);
              });
              _handleDateChange(_selectedYear);
            }
          },
        ),
      ],
    );
  }

  void _handleDateChange(DateTime newDate) {
    // Handle date change logic here
    print('Selected Year: $newDate');
    // Example of using a Cubit/Bloc to update state based on new date
    ReservationCubit.get(context).setYear(newDate);
  }
}
