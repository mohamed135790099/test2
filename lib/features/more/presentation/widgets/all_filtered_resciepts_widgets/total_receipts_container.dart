import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalReceiptsContainer extends StatelessWidget {
  final String total;

  const TotalReceiptsContainer({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
          color: AppColor.primaryBlueTransparent2,
          borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text(
          "إجمالي الفواتير $total ج.م",
          style: AppTextStyle.font18primaryBlue400,
        ),
      ),
    );
  }
}
