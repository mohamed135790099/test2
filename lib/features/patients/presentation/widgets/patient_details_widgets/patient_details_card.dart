import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_shadows.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/features/patients/presentation/widgets/patient_details_widgets/patient_details_card_item.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_details.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientDetailsCard extends StatelessWidget {
  final UserModel? userModel;

  const PatientDetailsCard({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        width: 335.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: AppShadows.shadow2,
            color: AppColor.white),
        child: Column(
          children: [
            PatientDetailsCardItem(
                title: AppStrings.patientName,
                widget: Text(
                  userModel?.fullName ?? "",
                  style: AppTextStyle.font12black700,
                )),
            9.hs,
            PatientDetailsCardItem(
                title: AppStrings.phoneNumber,
                widget: Text(
                  userModel?.phone ?? "",
                  style: AppTextStyle.font12black700,
                )),
          ],
        ));
  }
}
