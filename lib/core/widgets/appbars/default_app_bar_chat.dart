import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/presentation/pages/emergency_screen.dart';
import 'package:dr_mohamed_salah_admin/features/patients/presentation/pages/patients_details_screen.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultAppBarChat extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? id;

  const DefaultAppBarChat({super.key, required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColor.white,
      backgroundColor: AppColor.white,
      titleSpacing: 0,
      leadingWidth: 0,
      automaticallyImplyLeading: false,
      leading: const SizedBox(),
      toolbarHeight: 70.h,
      title: Row(
        children: [
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EmergencyScreen()),
              );
            },
            child: Center(
              child: AppImageView(
                svgPath: Assets.svgBackArrow,
                height: 24.h,
                width: 24.w,
              ),
            ),
          ),
          10.ws,
          Text(
            title,
            style: AppTextStyle.font18black700,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              if (id != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientsDetailsScreen(initialId: id),
                  ),
                );
              }
            },
            child: const Icon(
              Icons.person,
              color: AppColor.primaryBlue,
            ),
          ),
          const SizedBox(width: 12)
        ],
      ).withHorizontalPadding(10.w),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 70.h);
}
