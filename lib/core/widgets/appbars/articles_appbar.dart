import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/article/add_new_article.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticlesAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ArticlesAppbar({super.key});

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
            AppStrings.articles,
            style: AppTextStyle.font18black700,
          ),
          const Spacer(),
          TextButton(
              onPressed: () {
                showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) => const AddNewArticle());
              },
              child: Text(
                AppStrings.addNewArticle,
                style: AppTextStyle.font14primaryBlue500,
              ))
        ],
      ).withHorizontalPadding(10.w),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 70.h);
}
