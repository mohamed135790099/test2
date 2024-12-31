import 'dart:async';
import '../../../../core/widgets/appbars/default_appbar.dart';
import '../../../../utils/helpers/world_time_services.dart';
import '../../../reservations/data/models/get_all_reservations.dart';
import '../widgets/search_client_widget.dart';
import '/config/style/app_color.dart';
import '/features/home/presentation/widgets/home_buttons.dart';
import '/features/home/presentation/widgets/reservation_toggle.dart';
import '/features/reservations/presentation/manager/cubit.dart';
import '/features/reservations/presentation/manager/state.dart';
import '/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 5;
  Stream<int> counterStream = Stream<int>.periodic(
      const Duration(milliseconds: 300), (x) => refreshNum);
  final TextEditingController _searchClientController = TextEditingController();

  ScrollController? _scrollController;

  List<GetAllReservations> filteredReservations=[];

  final WorldTimeService _worldTimeService = WorldTimeService();

  String? formattedDate="";

  Future<void> _handleRefresh() async {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 500), () {
      ReservationCubit.get(context).fetchReservations(formattedDate.toString(),"pending");
      completer.complete();
    });

    setState(() {});
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
    _scrollController = ScrollController();
    // Fetch the current date and ensure it is a valid DateTime

  }




  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar:  DefaultAppBar(),
              body: LiquidPullToRefresh(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                color: AppColor.primaryBlue,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    const HomeButtons(),
                    12.hs,
                    SearchNameFormField(
                      nameController: _searchClientController, // Trigger search on text change
                      onChanged:(String clientName){
                        ReservationCubit.get(context).fetchReservations(
                            formattedDate.toString(),"pending",searchQuery:clientName);
                      },
                    ),
                    12.hs,
                    const ReservationToggle()
                  ],
                ),
              ),
            ),
            if (state is GetAllReservationsLoading ||
                state is GetOneReservationsLoading ||
                state is GetUserReservationsLoading)
              const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryBlue,
                  ))
            else if (state is GetAllReservationsSuccess)
              const SizedBox()
            else if (state is GetAllReservationsError)
                const Center(child: Text('Error fetching reservations')),
          ],
        );
      },
    );
  }
}
