import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/schedule_date_picker.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReservationDateForm extends StatefulWidget {
  final TextEditingController controller;

  final String? labelText;

  const ReservationDateForm(this.controller, {super.key, this.labelText});

  @override
  State<ReservationDateForm> createState() => _ReservationDateFormState();
}

class _ReservationDateFormState extends State<ReservationDateForm> {
  final ScheduleDatePicker _scheduleDatePicker = ScheduleDatePicker();

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      readOnly: true,
      controller: widget.controller,
      validator: ValidationForm.dateValidator,
      onTap: () async {
        final selectedDate = await _scheduleDatePicker.pickDate(context);

        setState(() {
          widget.controller.text = selectedDate;
        });

        ReservationCubit.get(context).fetchHours(widget.controller.text);
      },
      hintText: "YYYY/MM/DD",
      labelText: widget.labelText ?? AppStrings.reservationDate,
      fixIcon: SvgPicture.asset(
        Assets.svgCalendar,
        fit: BoxFit.scaleDown,
        width: 24.w,
        height: 24.h,
      ),
    );
  }
}
