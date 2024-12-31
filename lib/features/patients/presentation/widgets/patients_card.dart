import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_shadows.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/models/get_all_users.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientsCard extends StatelessWidget {
  final List<GetAllUsers> allUsers;
  final int index;
  final VoidCallback onTap;

  const PatientsCard({
    super.key,
    required this.allUsers,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          height: 60.h,
          width: 335.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: AppShadows.shadow2,
              color: AppColor.grey7),
          child: Row(
            children: [
              Text(
                "${allUsers[index].fullName}",
                style: AppTextStyle.font12black700,
              ),
              const Spacer(),
              AppImageView(
                svgPath: Assets.svgArrow,
                height: 12.h,
                width: 12.w,
                fit: BoxFit.scaleDown,
              )
            ],
          )),
    );
  }
}
