import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultAppbarActions extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions; // Add this line to accept actions

  const DefaultAppbarActions({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColor.white,
      backgroundColor: AppColor.white,
      titleSpacing: 0,
      leadingWidth: 0,
      actions: actions,
      automaticallyImplyLeading: false,
      leading: const SizedBox(),
      toolbarHeight: 70.h,
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
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
        ],
      ).withHorizontalPadding(10.w),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
