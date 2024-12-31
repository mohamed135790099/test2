import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/world_time_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleDatePicker {
  final WorldTimeService worldTimeService;

  ScheduleDatePicker({WorldTimeService? worldTimeService})
      : worldTimeService = worldTimeService ?? WorldTimeService();

  Future<String> pickDate(BuildContext context) async {
    DateTime initialDate;
    try {
      initialDate = await worldTimeService.getCurrentDateTime();
    } catch (e) {
      initialDate = DateTime.now();
    }

    String? formattedDate;
    DateTime? pickedDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              secondaryContainer: AppColor.white,
              onSecondary: AppColor.black,
              primary: AppColor.primaryBlue,
              onPrimary: AppColor.white,
              onSurface: AppColor.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primaryBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      formattedDate = DateFormat('yyyy-MM-dd', "en").format(pickedDate);
    }
    return formattedDate ?? "";
  }
}
