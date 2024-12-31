import '/core/widgets/buttons/button_1.dart';
import '/core/widgets/components/app_image_view.dart';
import '/features/home/presentation/widgets/patients_widgets/add_new_patient.dart';
import '/features/home/presentation/widgets/patients_widgets/add_new_reservation.dart';
import '/generated/assets.dart';
import '/utils/app_utils/app_strings.dart';
import '/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          AppButton1(
            onPressed: () async {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => const AddNewReservation());
            },
            width: 161.w,
            leading: AppImageView(
              svgPath: Assets.svgBook,
              height: 20.h,
              width: 24.w,
              fit: BoxFit.scaleDown,
            ),
            title: AppStrings.addNewReservation,
          ),
          8.ws,
          AppButton1(
            width: 165.w,
            leading: AppImageView(
              svgPath: Assets.svgPatient,
              height: 20.h,
              width: 24.w,
              fit: BoxFit.scaleDown,
            ),
            title: AppStrings.addNewPatient,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => const AddNewPatient());
            },
          ),
        ],
      ),
    );
  }
}
