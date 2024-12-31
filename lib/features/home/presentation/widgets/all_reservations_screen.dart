import '/config/style/app_color.dart';
import '/core/widgets/appbars/default_appbar_2.dart';
import '/features/home/presentation/widgets/reservation_card.dart';
import '/features/reservations/data/models/get_all_reservations.dart';
import '/features/reservations/presentation/manager/cubit.dart';
import '/features/reservations/presentation/manager/state.dart';
import '/utils/app_utils/app_strings.dart';
import '/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllReservationsScreen extends StatelessWidget {
  const AllReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final List<GetAllReservations> allReservations =
            ReservationCubit.get(context).allReservations;
        allReservations.sort((a, b) => a.date!.compareTo(b.date!));
        return Stack(
          children: [
            Scaffold(
              appBar: DefaultAppBar2(
                title: AppStrings.reservations,
              ),
              body: allReservations.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                height: 800.h,
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 60.h),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ReservationCard(
                      index: index, sortedList: allReservations),
                  separatorBuilder: (context, index) => 12.hs,
                  itemCount: allReservations.length,
                ),
              ),
            ),
            state is GetAllReservationsLoading ||
                state is GetOneReservationsLoading ||
                state is GetUserReservationsLoading
                ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryBlue,
                ))
                : const SizedBox()
          ],
        );
      },
    );
  }
}
