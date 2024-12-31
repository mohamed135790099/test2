import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientDetailsCardItem extends StatelessWidget {
  final String title;
  final Widget widget;

  const PatientDetailsCardItem(
      {super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyle.font12black400,
        ),
        8.ws,
        SizedBox(
          height: 20.h,
          child: const VerticalDivider(
            color: AppColor.grey4,
            thickness: 1,
          ),
        ),
        8.ws,
        widget
      ],
    );
  }
}
