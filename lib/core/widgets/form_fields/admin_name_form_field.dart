import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminNameFormField extends StatelessWidget {
  final TextEditingController nameController;

  const AdminNameFormField({super.key, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      disableBorder: true,
      radius: 8.r,
      labelText: AppStrings.adminName,
      controller: nameController,
      hintText: AppStrings.pleaseEnterName,
      validator: ValidationForm.firstNameValidator,
    );
  }
}
