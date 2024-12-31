import 'package:dotted_border/dotted_border.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UploadArticleImage extends StatelessWidget {
  final XFile? image;
  final String title;
  final double? height;
  final VoidCallback onPressed;
  final VoidCallback onPressedRemove;

  const UploadArticleImage(
      {super.key,
      this.image,
      required this.title,
      required this.onPressed,
      required this.onPressedRemove,
      this.height});

  @override
  Widget build(BuildContext context) {
    return image != null
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AppImageView(
                file: image,
                fit: BoxFit.fill,
                width: 90.w,
                height: 120.h,
                radius: BorderRadius.circular(8),
              ),
              InkWell(
                  onTap: onPressedRemove,
                  child: AppImageView(
                    svgPath: Assets.svgDelete,
                    height: 24.h,
                    width: 24.w,
                    fit: BoxFit.scaleDown,
                  )).withVerticalPadding(10)
            ],
          )
        : InkWell(
            onTap: onPressed,
            child: SizedBox(
              width: 335.w,
              height: height ?? 90.h,
              child: DottedBorder(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                radius: const Radius.circular(8),
                color: AppColor.primaryBlue,
                strokeWidth: 1,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppImageView(
                        svgPath: Assets.svgUpload,
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.scaleDown,
                      ),
                      8.ws,
                      Text(
                        title,
                        style: AppTextStyle.font14primaryBlue500,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
