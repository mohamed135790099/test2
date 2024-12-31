import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton5 extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final VoidCallback? onPressed;
  final double? horizontalTitleGap;
  final double? width;

  const AppButton5({
    super.key,
    this.title,
    this.leading,
    this.onPressed,
    this.horizontalTitleGap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ButtonStyle(
            side:
                const WidgetStatePropertyAll(BorderSide(color: AppColor.white)),
            fixedSize: WidgetStatePropertyAll(Size(width ?? 343.w, 60.h)),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.white),
            overlayColor: const WidgetStatePropertyAll(AppColor.white),
            backgroundColor: const WidgetStatePropertyAll(AppColor.white),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)))),
        child: leading == null
            ? Center(
                child: Text(
                  title ?? "",
                  style: AppTextStyle.font16blue500,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  leading!,
                  horizontalTitleGap?.ws ?? 20.ws,
                  Text(
                    title ?? "",
                    style: AppTextStyle.font16blue500,
                  ),
                ],
              ));
  }
}
