import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_2.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_4.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CloseChatModalSheet extends StatelessWidget {
  const CloseChatModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: AppColor.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.areYouSureToCloseChat,
            style: AppTextStyle.font18black700,
          ),
          16.hs,
          Text(
            AppStrings.patientCantContact,
            style: AppTextStyle.font14black400,
            textAlign: TextAlign.center,
          ),
          16.hs,
          Row(
            children: [
              Expanded(
                  child: AppButton4(
                title: AppStrings.close,
                width: 150.w,
              )),
              12.ws,
              Expanded(
                  child: AppButton2(
                title: AppStrings.stay,
                width: 150.w,
              ))
            ],
          )
        ],
      ).withVerticalPadding(20).withHorizontalPadding(20),
    );
  }
}
