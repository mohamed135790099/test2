import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NameFormField extends StatelessWidget {
  final TextEditingController nameController;

  const NameFormField({super.key, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      inputFormatter: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^[\u0600-\u06FFa-zA-Z\s]*$')),
      ],
      keyboardType: TextInputType.text,
      radius: 8.r,
      labelText: AppStrings.name,
      controller: nameController,
      hintText: AppStrings.pleaseEnterName,
      validator: ValidationForm.firstNameValidator,
    );
  }
}
