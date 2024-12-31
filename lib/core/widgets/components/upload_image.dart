import 'package:dotted_border/dotted_border.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatelessWidget {
  final List<XFile>? images;
  final String title;
  final double? height;
  final VoidCallback onPressed;
  final void Function(XFile) onPressedRemove;

  const UploadImage({
    super.key,
    this.images,
    required this.title,
    required this.onPressed,
    required this.onPressedRemove,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (images != null && images!.isNotEmpty)
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: images!.map((image) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  AppImageView(
                    file: image,
                    fit: BoxFit.fill,
                    width: 90.w,
                    height: 120.h,
                    radius: BorderRadius.circular(8),
                  ),
                  InkWell(
                    onTap: () => onPressedRemove(image),
                    child: AppImageView(
                      svgPath: Assets.svgDelete,
                      height: 24.h,
                      width: 24.w,
                      fit: BoxFit.scaleDown,
                    ),
                  ).withVerticalPadding(10)
                ],
              );
            }).toList(),
          ),
        if (images == null || images!.length < 5)
          InkWell(
            onTap: onPressed,
            child: SizedBox(
              width: 335.w,
              height: height ?? 90.h,
              child: Container(
                margin: const EdgeInsetsDirectional.only(top: 12),
                child: DottedBorder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
            ),
          ),
      ],
    );
  }
}
