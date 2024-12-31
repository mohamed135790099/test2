import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_2.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_user_medicine.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/medicines_widgets/add_new_medicine.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/medicines_widgets/medicines_card.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicinesList extends StatefulWidget {
  String patientId;

  MedicinesList({super.key, required this.patientId});

  @override
  State<MedicinesList> createState() => _MedicinesListState();
}

class _MedicinesListState extends State<MedicinesList> {
  @override
  void initState() {
    super.initState();
    context.read<ReservationCubit>().getUserReservations(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final List<GetUserMedicine> userMedicines =
            ReservationCubit.get(context).userMedicines;

        return SizedBox(
            height: 530.h,
            child: Scaffold(
              bottomSheet: AppButton2(
                title: AppStrings.addMedicine,
                onPressed: () {
                  showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (context) => const AddNewMedicine());
                },
              ),
              body: ListView.separated(
                  padding: EdgeInsets.only(bottom: 50.h, top: 20.h),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => MedicinesCard(
                        userMedicine: userMedicines,
                        index: index,
                      ),
                  separatorBuilder: (context, index) => 12.hs,
                  itemCount: userMedicines.length),
            ));
      },
    );
  }
}
