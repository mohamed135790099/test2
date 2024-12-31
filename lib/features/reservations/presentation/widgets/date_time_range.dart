import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeRangePicker extends StatefulWidget {
  final void Function(DateTimeRange pickedRange)? onRangeChanged;

  const DateTimeRangePicker({super.key, this.onRangeChanged});

  @override
  _DateTimeRangePickerState createState() => _DateTimeRangePickerState();
}

class _DateTimeRangePickerState extends State<DateTimeRangePicker> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDateRange(context),
      child: Text('Select Date Range', style: AppTextStyle.font12black700),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final pickedRange = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Date Range', style: AppTextStyle.font12black700),
            20.hs,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => _selectStartDate(context),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_startDate),
                    style: AppTextStyle.font12black700,
                  ),
                ),
                TextButton(
                  onPressed: () => _selectEndDate(context),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_endDate),
                    style: AppTextStyle.font12black700,
                  ),
                ),
              ],
            ),
            20.hs,
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(DateTimeRange(start: _startDate, end: _endDate));
              },
              child: Text('Apply', style: AppTextStyle.font12black700),
            ),
          ],
        ),
      ),
    );

    if (pickedRange != null) {
      setState(() {
        _startDate = pickedRange.start;
        _endDate = pickedRange.end;
      });
      widget.onRangeChanged?.call(pickedRange);
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              secondaryContainer: AppColor.white,
              onSecondary: AppColor.black,
              primary: AppColor.primaryBlue,
              // header background color
              onPrimary: AppColor.white,
              // header text color
              onSurface: AppColor.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primaryBlue, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              secondaryContainer: AppColor.white,
              onSecondary: AppColor.black,
              primary: AppColor.primaryBlue,
              // header background color
              onPrimary: AppColor.white,
              // header text color
              onSurface: AppColor.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primaryBlue, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }
}
