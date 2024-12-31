import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;

  const PasswordFormField(
      {super.key, required this.controller, this.labelText});

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _showPass = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      obscureText: _showPass,
      keyboardType: TextInputType.visiblePassword,
      validator: ValidationForm.passwordValidator,
      fixIcon: InkWell(
        onTap: () {
          setState(() {
            _showPass = !_showPass;
          });
        },
        child: AppImageView(
          svgPath: Assets.svgHidePassword,
          fit: BoxFit.scaleDown,
          width: 24.w,
          height: 24.h,
        ),
      ),
      labelText: AppStrings.password,
      hintText: AppStrings.pleaseEnterPassword,
    );
  }
}
