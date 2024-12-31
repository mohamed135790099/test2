import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_actions.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_one_prescription.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/prescriptions_widgets/add_new_prescription.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widget_zoom/widget_zoom.dart';

class PrescriptionsDetailsScreen extends StatefulWidget {
  final String prescriptionId;

  const PrescriptionsDetailsScreen({super.key, required this.prescriptionId});

  @override
  State<PrescriptionsDetailsScreen> createState() =>
      _PrescriptionsDetailsScreenState();
}

class _PrescriptionsDetailsScreenState
    extends State<PrescriptionsDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final GetOnePrescription? getOnePrescription =
        ReservationCubit.get(context).getUserPrescription;
    final ReservationCubit cubit = ReservationCubit.get(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الروشتة'),
        content: const Text('هل انت متأكد من حذف هذا الروشتة ؟'),
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
              cubit.deletePrescription(getOnePrescription?.sId ?? "",
                  cubit.getUserDetail?.sId ?? "");
              Navigator.of(context).pop();
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

  void _navigateToEditPrescription(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddNewPrescription(prescriptionId: widget.prescriptionId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<ReservationCubit>().getOnePrescription(widget.prescriptionId);
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final GetOnePrescription? getOnePrescription =
            ReservationCubit.get(context).getUserPrescription;
        if (state is DeletePrescriptionSuccess) {
          AppToaster.show("تم الحذف بنجاح");
        }
        return Stack(children: [
          Scaffold(
            backgroundColor: AppColor.white,
            appBar: DefaultAppbarActions(
              title: "Prescription Details",
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_calendar_rounded),
                  onPressed: () {
                    _navigateToEditPrescription(context);
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
                if (getOnePrescription?.image != null &&
                    (getOnePrescription?.image?.isNotEmpty ?? false))
                  Column(
                    children: getOnePrescription!.image!.map((imageUrl) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: WidgetZoom(
                          heroAnimationTag: 'tag',
                          zoomWidget: AppImageView(
                            url: imageUrl,
                            height: 200.h,
                            width: 335.w,
                            fit: BoxFit.contain,
                          ),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(
                      color: AppColor.grey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    getOnePrescription?.title ?? 'No Title available',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(
                      color: AppColor.primaryBlueTransparent,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    getOnePrescription?.terms ?? "No details available",
                    style: AppTextStyle.font14black500,
                  ),
                )
              ],
            ),
          ),
          state is DeletePrescriptionLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: AppColor.primaryBlue,
                ))
              : const SizedBox()
        ]);
      },
    );
  }
}
