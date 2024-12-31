import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeFormField extends StatelessWidget {
  final TextEditingController pinController;

  const PinCodeFormField({super.key, required this.pinController});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        appContext: context,
        pastedTextStyle: const TextStyle(
          color: AppColor.black,
          fontWeight: FontWeight.bold,
        ),
        length: 6,
        animationType: AnimationType.fade,
        validator: ValidationForm.codeValidator,
        mainAxisAlignment: MainAxisAlignment.center,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          fieldHeight: 50.h,
          fieldOuterPadding: EdgeInsets.zero,
          fieldWidth: 50.h,
          inactiveFillColor: Colors.transparent,
          inactiveColor: AppColor.grey,
          selectedFillColor: Colors.transparent,
          selectedColor: AppColor.grey,
          activeFillColor: Colors.transparent,
          activeColor: AppColor.grey,
          activeBorderWidth: 1,
          selectedBorderWidth: 1,
        ),
        separatorBuilder: (context, index) => 10.ws,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        cursorColor: AppColor.black,
        textStyle: AppTextStyle.font16black400,
        controller: pinController,
        errorTextSpace: 25.h,
        errorTextMargin: EdgeInsets.only(left: 30.w),
        keyboardType: TextInputType.number,
        onCompleted: (v) {
          debugPrint("Completed");
        },
        onChanged: (value) {},
        beforeTextPaste: (text) {
          debugPrint("Allowing to paste $text");
          return true;
        },
      ),
    );
  }
}
