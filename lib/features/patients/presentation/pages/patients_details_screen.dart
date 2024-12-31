import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/defualt_appbar3.dart';
import 'package:dr_mohamed_salah_admin/features/patients/presentation/widgets/patient_details_widgets/patient_details_toggle.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientsDetailsScreen extends StatefulWidget {
  String? initialId;

  PatientsDetailsScreen({super.key, this.initialId});

  @override
  State<PatientsDetailsScreen> createState() => _PatientsDetailsScreenState();
}

class _PatientsDetailsScreenState extends State<PatientsDetailsScreen> {
  String? id;

  @override
  void initState() {
    super.initState();
    id = widget.initialId;
    if (id != null) {
      ReservationCubit.get(context).getUserDetails(id ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        if (state is GetUserReservationsLoading) {
          const Center(
            child: CircularProgressIndicator(
              color: AppColor.primaryBlue,
            ),
          );
        }

        return Scaffold(
          appBar: DefaultAppBar3(
            title: AppStrings.patientDetails,
            patientId: id ?? "Unknown ID",
          ),
          body: Stack(
            children: [
              PatientDetailsToggle(id: id ?? "Unknown ID"),
              if (state is ReservationLoading ||
                  state is GetLastReservationsLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryBlue,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
