import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../config/style/app_color.dart';
import '../../data/model/new_reservation_model.dart';
import '/features/reservations/presentation/manager/cubit.dart';
import '/features/reservations/presentation/manager/state.dart';
import '/utils/helpers/world_time_services.dart';
import 'patients_widgets/new_reservation_card.dart';

class WaitingReservationList extends StatefulWidget {
  const WaitingReservationList({super.key});

  @override
  State<WaitingReservationList> createState() => _WaitingReservationListState();
}

class _WaitingReservationListState extends State<WaitingReservationList> {
  final WorldTimeService _worldTimeService = WorldTimeService();
  String? formattedDate;
  List<Reservations> _reservations = []; // متغير محلي لتخزين البيانات
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentDateTimeAndReservations();
  }

  void _fetchCurrentDateTimeAndReservations() async {
    final currentDateTime = await _worldTimeService.getCurrentDateTime();
    formattedDate = DateFormat('yyyy-MM-dd').format(currentDateTime);
    await context
        .read<ReservationCubit>()
        .fetchReservations(formattedDate!, "pending");
  }

  @override
  Widget build(BuildContext context) {
    _reservations = context.read<ReservationCubit>().allTodayReservations;

    return BlocListener<ReservationCubit, ReservationState>(
      listener: (context, state) {
        if (state is FilteredReservationLoadingState && _reservations.isEmpty) {
          setState(() => _isLoading = true);
        }
        else if (state is FilteredReservationSuccessState) {
          setState(() {
            _reservations = state.reservations;
            _isLoading = false;
            // حفظ البيانات في المتغير المحلي
          });
        } else if (state is FilteredReservationErrorState) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: _isLoading?const Center(child:CircularProgressIndicator(
        color:AppColor.primaryBlue,
      ),):_reservations.isEmpty
          ? const Center(
        child: Text("No reservations found"),
      )
          : SizedBox(
        height: 500.h,
        child: ListView.builder(
          itemCount: _reservations.length,
          itemBuilder: (context, index) {
            final reservation = _reservations[index];
            return NewReservationCard(
              index: index,
              sortedList: _reservations,
            );
          },
        ),
      ),
    );
  }
}


