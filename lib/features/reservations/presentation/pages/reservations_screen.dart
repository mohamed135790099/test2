import 'dart:async';
import '../../../../utils/helpers/world_time_services.dart';
import '/config/style/app_color.dart';
import '/core/widgets/appbars/total_booking_appbar.dart';
import '/features/reservations/presentation/manager/cubit.dart';
import '/features/reservations/presentation/manager/state.dart';
import '/features/reservations/presentation/widgets/date_timeline_widget.dart';
import '/features/reservations/presentation/widgets/reservation_toggle_by_date.dart';
import '/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:intl/intl.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 5;
  Stream<int> counterStream = Stream<int>.periodic(const Duration(milliseconds: 300), (x) => refreshNum);

  final WorldTimeService _worldTimeService = WorldTimeService();

  String? formattedDate="";

  Future<void> _handleRefresh() async {
    final completer = Completer<void>();
    Timer(const Duration(milliseconds: 500), completer.complete);

    ReservationCubit.get(context).fetchReservations(formattedDate.toString(),"pending");

    return completer.future.then<void>((_) {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            onPressed: () {
              _refreshIndicatorKey.currentState!.show();
            },
          ),
        ),
      );
    });
  }

  _bind()async{
    final currentDateTime = await _worldTimeService.getCurrentDateTime();
    if (currentDateTime != null) {
      formattedDate = DateFormat('yyyy-MM-dd').format(currentDateTime);
    } else {
      formattedDate = ""; // Fallback in case currentDateTime is null or invalid
    }
  }

  @override
  void initState() {
    super.initState();
    _bind();
    ReservationCubit.get(context).getAllReservations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: const TotalBookingsAppbar(),
              body: LiquidPullToRefresh(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                color: AppColor.primaryBlue,
                child: Column(
                  children: [
                    const DateTimeline(),
                    12.hs,
                    const ReservationToggleByDate()
                  ],
                ),
              ),
            ),
            if (state is GetReservationsByDateLoading || state is GetUserReservationsLoading || state is GetOneReservationsLoading)
              const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryBlue,
                  ))
          ],
        );
      },
    );
  }
}
