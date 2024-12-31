import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/patients_widgets/new_reservation_card.dart';

import '../../data/model/new_reservation_model.dart';
import '/config/style/app_color.dart';
import '/features/reservations/presentation/manager/cubit.dart';
import '/features/reservations/presentation/manager/state.dart';
import '/utils/helpers/world_time_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class EndedReservationList extends StatefulWidget {
  const EndedReservationList({super.key});

  @override
  State<EndedReservationList> createState() => _EndedReservationListState();
}

class _EndedReservationListState extends State<EndedReservationList> {
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
    if(context.mounted){
      await context.read<ReservationCubit>().fetchReservationsByStatuses(
        formattedDate!,
        ["confirmed", "canceled"],
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    _reservations = context.read<ReservationCubit>().endedReservations;

    return BlocListener<ReservationCubit, ReservationState>(
      listener: (context, state) {
        if (state is EndedReservationLoadingState && _reservations.isEmpty) {
          setState(() => _isLoading = true);
        }
        if (state is EndedReservationSuccessState) {
          setState(() {
            _reservations = state.reservations;
            _isLoading = false;
          });
        } else if (state is EndedReservationErrorState) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: _isLoading? const Center(
        child: CircularProgressIndicator(
          color:AppColor.primaryBlue,
        ),
      ):_reservations.isEmpty
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
