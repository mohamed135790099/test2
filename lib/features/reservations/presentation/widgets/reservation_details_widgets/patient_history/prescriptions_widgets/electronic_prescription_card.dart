import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_shadows.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_electronic_prescription.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/elec_prescription_cubit.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_route_name.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElectronicPrescriptionsCard extends StatelessWidget {
  final List<GetUserElectronicPrescription> userElectronicPrescription;
  final int index;

  const ElectronicPrescriptionsCard(
      {super.key,
      required this.userElectronicPrescription,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onCardTap(context),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          height: 60.h,
          width: 335.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: AppShadows.shadow2,
              color: AppColor.white),
          child: Row(
            children: [
              Text(
                "${AppStrings.electronicPrescriptionNumber} ${index + 1}",
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

  void _onCardTap(BuildContext context) {
    final prescriptionId = userElectronicPrescription[index].id;
    if (prescriptionId.isNotEmpty) {
      ElectronicPrescriptionCubit.get(context)
          .getElectronicPrescriptionById(userElectronicPrescription[index].id)
          .then((value) => RouterApp.pushNamed(
              RouteName.electricPrescriptionDetails,
              arguments: prescriptionId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Electronic Prescription ID is invalid.')),
      );
    }
  }
}
