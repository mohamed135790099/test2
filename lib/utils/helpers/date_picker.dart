import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/world_time_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker {
  final WorldTimeService _worldTimeService = WorldTimeService();

  Future<String> pickDate(BuildContext context) async {
    String? formattedDate;
    DateTime currentDateTime = await _worldTimeService.getCurrentDateTime();

    DateTime? pickedDate = await showDatePicker(
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
        initialDate: currentDateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      formattedDate = DateFormat('yyyy-MM-dd', "en").format(pickedDate);
    }
    return formattedDate ?? "";
  }
}
