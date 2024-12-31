import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleFormField extends StatelessWidget {
  final TextEditingController titleController;

  const TitleFormField({super.key, required this.titleController});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      trailingLabel: AppImageView(
        svgPath: Assets.svgPen,
        height: 24.h,
        width: 24.w,
        fit: BoxFit.scaleDown,
      ),
      isMultiLine: false,
      radius: 8.r,
      labelText: AppStrings.title,
      controller: titleController,
      hintText: AppStrings.pleaseEnterDetails,
      validator: ValidationForm.firstNameValidator,
    );
  }
}
