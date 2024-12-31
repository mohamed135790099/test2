import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_2.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_xray.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/xray_widgets/add_new_xray.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/xray_widgets/xray_card.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class XRayList extends StatefulWidget {
  String patientId;

  XRayList({super.key, required this.patientId});

  @override
  State<XRayList> createState() => _XRayListState();
}

class _XRayListState extends State<XRayList> {
  @override
  void initState() {
    super.initState();
    context.read<ReservationCubit>().getUserReservations(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final List<GetUserXRay> userXRays =
            ReservationCubit.get(context).userXRays;

        return SizedBox(
            height: 530.h,
            child: Scaffold(
              bottomSheet: AppButton2(
                title: AppStrings.addXRay,
                onPressed: () {
                  showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (context) => const AddNewXRay());
                },
              ),
              body: ListView.separated(
                  padding: EdgeInsets.only(bottom: 50.h, top: 20.h),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => XRayCard(
                        userXRay: userXRays,
                        index: index,
                      ),
                  separatorBuilder: (context, index) => 12.hs,
                  itemCount: userXRays.length),
            ));
      },
    );
  }
}
