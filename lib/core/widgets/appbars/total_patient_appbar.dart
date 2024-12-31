import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_1.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/models/get_all_users.dart';
import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/patients_widgets/add_new_patient.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalPatientsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const TotalPatientsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: AppColor.white)),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      surfaceTintColor: AppColor.white,
      backgroundColor: AppColor.white,
      titleSpacing: 0,
      leadingWidth: 0,
      leading: const SizedBox(),
      toolbarHeight: 70.h,
      title: BlocBuilder<ReservationCubit, ReservationState>(
        builder: (context, state) {
          final List<GetAllUsers> allUsers =
              ReservationCubit.get(context).allUsers;

          return Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppImageView(
                        svgPath: Assets.svgPatient,
                        height: 20.h,
                        width: 20.w,
                      ),
                      8.ws,
                      Text(
                        AppStrings.totalPatients,
                        style: AppTextStyle.font14black400,
                      ),
                    ],
                  ),
                  Text(
                    "${allUsers.length}",
                    style: AppTextStyle.font20black900,
                  )
                ],
              ),
              const Spacer(),
              AppButton1(
                width: 165.w,
                leading: AppImageView(
                  svgPath: Assets.svgPatient,
                  height: 16.h,
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
          );
        },
      ).withHorizontalPadding(20),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 70.h);
}
