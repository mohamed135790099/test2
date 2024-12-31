import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/date_picker.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class BillCalendarDateForm extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String addressText;
  final VoidCallback onDateSelected;

  const BillCalendarDateForm(
    this.controller, {
    super.key,
    this.labelText,
    required this.addressText,
    required this.onDateSelected,
  });

  @override
  State<BillCalendarDateForm> createState() => _BillCalendarDateFormState();
}

class _BillCalendarDateFormState extends State<BillCalendarDateForm> {
  final DatePicker _datePicker = DatePicker();

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      readOnly: true,
      controller: widget.controller,
      validator: ValidationForm.dateValidator,
      onTap: () async {
        String? pickedDate = await _datePicker.pickDate(context);
        DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(pickedDate);
        String formattedDate =
            DateFormat('yyyy-MM-dd', 'en').format(selectedDate);
        setState(() {
          widget.controller.text = formattedDate;
          widget.onDateSelected();
        });
      },
      hintText: "DD/MM/YY",
      labelText: widget.addressText,
      fixIcon: SvgPicture.asset(
        'assets/svg/Calendar.svg', // Adjust path as needed
        fit: BoxFit.scaleDown,
        width: 24.0,
        height: 24.0,
      ),
    );
  }
}
