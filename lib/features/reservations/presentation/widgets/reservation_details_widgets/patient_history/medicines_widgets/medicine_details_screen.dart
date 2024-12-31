import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_actions.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/patients/presentation/pages/patients_details_screen.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_one_medicine.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/medicines_widgets/add_new_medicine.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicineDetailsScreen extends StatefulWidget {
  final String medicineId;

  const MedicineDetailsScreen({super.key, required this.medicineId});

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  void _showDeleteConfirmationDialog(BuildContext context) {
    final GetOneMedicine? getOneMedicine =
        ReservationCubit.get(context).getUserMedicine;
    final ReservationCubit cubit = ReservationCubit.get(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الدواء'),
        content: const Text('هل انت متأكد من حذف هذا الدواء ؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: AppTextStyle.font14red500,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              cubit.deleteMedicine(
                  getOneMedicine?.sId ?? "", cubit.getUserDetail?.sId ?? "");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientsDetailsScreen(),
                ),
              );
            },
            child: Text(
              'حذف',
              style: AppTextStyle.font14red500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditMedicine(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddNewMedicine(medicineId: widget.medicineId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<ReservationCubit>().getOneMedicine(widget.medicineId);

    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final GetOneMedicine? getUserMedicine =
            ReservationCubit.get(context).getUserMedicine;

        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: DefaultAppbarActions(
            title: "Medicine Details",
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_calendar_rounded),
                onPressed: () {
                  _navigateToEditMedicine(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever, color: AppColor.red),
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            children: [
              if (getUserMedicine?.image != null &&
                  (getUserMedicine?.image?.isNotEmpty ?? false))
                Column(
                  children: getUserMedicine!.image!.map((imageUrl) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: AppImageView(
                        url: imageUrl,
                        height: 200.h,
                        width: 335.w,
                        fit: BoxFit.fill,
                      ),
                    );
                  }).toList(),
                )
              else
                Center(
                  child: Text(
                    'No images available',
                    style: AppTextStyle.font14black500,
                  ),
                ),
              12.hs,
              Row(
                children: [
                  AppImageView(
                    svgPath: Assets.svgPen,
                    height: 24.h,
                    width: 24.w,
                    fit: BoxFit.scaleDown,
                  ),
                  10.ws,
                  Text(
                    'Title',
                    style: AppTextStyle.font14black500,
                  ),
                ],
              ),
              12.hs,
              Container(
                width: 335.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                    color: AppColor.grey,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  getUserMedicine?.title ?? 'No Title available',
                  style: AppTextStyle.font14black500,
                ),
              ),
              12.hs,
              Row(
                children: [
                  AppImageView(
                    svgPath: Assets.svgDetails,
                    height: 24.h,
                    width: 24.w,
                    fit: BoxFit.scaleDown,
                  ),
                  10.ws,
                  Text(
                    AppStrings.details,
                    style: AppTextStyle.font14black500,
                  ),
                ],
              ),
              12.hs,
              Container(
                width: 335.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                    color: AppColor.primaryBlueTransparent,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  getUserMedicine?.terms ?? "No details available",
                  style: AppTextStyle.font14black500,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
