import 'dart:io';

import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class MorePictureItem extends StatelessWidget {
  final String doctorName;

  const MorePictureItem({
    Key? key,
    required this.doctorName,
  }) : super(key: key);

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File file = File(image.path);
      MoreCubit.get(context).uploadImage(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 180.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: AppImageView(
                imagePath: Assets.tempDocCover,
                height: 180.h,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned.fill(
            top: 120.h,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: AppColor.white,
                              shape: BoxShape.circle,
                            ),
                            height: 105.h,
                            width: 105.w,
                            child: const SizedBox(),
                          ),
                          AppImageView(
                            imagePath: Assets.docPic,
                            height: 90.h,
                            shape: BoxShape.circle,
                            width: 100.w,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      // InkWell(
                      //   onTap: () => _pickAndUploadImage(context),
                      //   child: AppImageView(
                      //     svgPath: Assets.svgPen,
                      //     height: 24.h,
                      //     width: 24.w,
                      //     fit: BoxFit.cover,
                      //   ).withVerticalPadding(10),
                      // ),
                    ],
                  ),
                  1.hs,
                  Expanded(
                    child: Text(
                      doctorName,
                      style: AppTextStyle.font16black700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
