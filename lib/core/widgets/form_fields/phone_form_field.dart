import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneFormField extends StatelessWidget {
  final TextEditingController phoneController;

  const PhoneFormField({super.key, required this.phoneController});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      keyboardType: TextInputType.number,
      inputFormatter: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      radius: 12,
      labelText: AppStrings.phoneNumber,
      controller: phoneController,
      hintText: AppStrings.pleaseEnterPhoneNumber,
      validator: ValidationForm.phoneValidator,
    );
  }
}
