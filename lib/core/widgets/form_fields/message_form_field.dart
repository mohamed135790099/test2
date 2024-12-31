import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageFormField extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onPressed;

  MessageFormField({
    super.key,
    required this.messageController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      fixIcon: InkWell(
          onTap: onPressed,
          child: AppImageView(
            svgPath: Assets.svgSend,
            height: 32.h,
            width: 32.w,
            fit: BoxFit.scaleDown,
          )),
      radius: 8.r,
      controller: messageController,
      hintText: AppStrings.pleaseEnterMessage,
      validator: ValidationForm.firstNameValidator,
    );
  }
}
