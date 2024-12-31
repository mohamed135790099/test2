import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleNameFormField extends StatelessWidget {
  final TextEditingController articleNameController;

  const ArticleNameFormField({super.key, required this.articleNameController});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      radius: 8.r,
      labelText: AppStrings.articleName,
      controller: articleNameController,
      hintText: AppStrings.pleaseEnterArticleName,
      validator: ValidationForm.firstNameValidator,
    );
  }
}
