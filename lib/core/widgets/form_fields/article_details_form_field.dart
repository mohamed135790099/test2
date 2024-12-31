import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleDetailsFormField extends StatelessWidget {
  final TextEditingController articleDetailsController;

  const ArticleDetailsFormField(
      {super.key, required this.articleDetailsController});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      isMultiLine: true,
      radius: 8.r,
      labelText: AppStrings.articleDetails,
      controller: articleDetailsController,
      hintText: AppStrings.pleaseEnterArticleDetails,
      validator: ValidationForm.firstNameValidator,
    );
  }
}
