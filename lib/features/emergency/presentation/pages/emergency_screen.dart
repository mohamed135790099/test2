import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/screens/main_screen.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/presentation/widgets/waiting_emergency/waiting_emergency_list.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  void initState() {
    super.initState();
    initializeAllChats();
  }

  Future<void> initializeAllChats() async {
    await context.read<ReservationCubit>().getAdminAllConversations();
    context.read<ReservationCubit>().allConversations;
  }

  Future<void> _refreshData() async {
    await context.read<ReservationCubit>().getAdminAllConversations();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) =>  MainScreen()),
          (route) => route.isFirst,
        );
        return false;
      },
      child: BlocListener<ReservationCubit, ReservationState>(
        listener: (context, state) {
          if (state is GetAllConversationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load conversations.')),
            );
          }
          if (state is GetAllConversationLoading) {
            const Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryBlue,
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColor.primaryBlue,
          child: Scaffold(
            body: BlocBuilder<ReservationCubit, ReservationState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 700.h,
                            child: const WaitingEmergencyList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
