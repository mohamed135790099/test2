import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_4.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/reservation_details_toggle.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationDetailsScreen extends StatelessWidget {
  String? initialId;

  ReservationDetailsScreen({super.key, this.initialId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: DefaultAppBarReservation(
                title: AppStrings.reservationDetails,
                id: initialId,
              ),
              body: ReservationDetailsToggle(id: initialId ?? ""),
            ),
            if (state is GetOneReservationsLoading ||
                state is GetUserReservationsLoading ||
                state is GetUserDetailsLoading ||
                state is GetLastReservationsLoading)
              const Center(
                child: Center(
                    child:
                        CircularProgressIndicator(color: AppColor.primaryBlue)),
              ),
          ],
        );
      },
    );
  }
}
