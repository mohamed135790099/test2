import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton3 extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final VoidCallback? onPressed;
  final double? horizontalTitleGap;
  final bool isValid;

  const AppButton3({
    super.key,
    this.title,
    this.leading,
    this.onPressed,
    this.horizontalTitleGap,
    this.isValid = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: isValid ? onPressed : () {},
        style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size(343.w, 55.h)),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
            overlayColor: WidgetStatePropertyAll(isValid
                ? AppColor.primaryBlue
                : AppColor.primaryBlueTransparent),
            backgroundColor: WidgetStatePropertyAll(isValid
                ? AppColor.primaryBlue
                : AppColor.primaryBlueTransparent),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)))),
        child: leading == null
            ? Center(
                child: Text(
                  title ?? "",
                  style: AppTextStyle.font16white500,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  leading!,
                  horizontalTitleGap?.ws ?? 20.ws,
                  Text(
                    title ?? "",
                    style: AppTextStyle.font16white500,
                  ),
                ],
              ));
  }
}
