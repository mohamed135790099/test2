import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_shadows.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreButtonsItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final String icon;

  const MoreButtonsItem(
      {super.key, required this.title, this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        decoration: BoxDecoration(
            boxShadow: AppShadows.shadow2,
            borderRadius: BorderRadius.circular(6),
            color: AppColor.white),
        child: Row(
          children: [
            AppImageView(
              svgPath: icon,
              height: 24.h,
              width: 24.w,
              fit: BoxFit.scaleDown,
            ),
            10.ws,
            Text(
              title,
              style: AppTextStyle.font16black2400,
            ),
            const Spacer(),
            AppImageView(
              svgPath: Assets.svgArrow,
              height: 12.h,
              width: 12.w,
            )
          ],
        ),
      ),
    );
  }
}
