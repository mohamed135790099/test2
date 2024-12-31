import 'dart:developer';

import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/data/models/conversations_model.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/presentation/widgets/waiting_emergency/emergency_waiting_chat_card.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class WaitingEmergencyList extends StatefulWidget {
  const WaitingEmergencyList({super.key});

  @override
  State<WaitingEmergencyList> createState() => _WaitingEmergencyListState();
}

class _WaitingEmergencyListState extends State<WaitingEmergencyList> {
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  bool _pusherInitialized = false;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _initializePusher();
  }

  Future<void> _initializePusher() async {
    await context.read<ReservationCubit>().getAdminAllConversations();
    await initPusher();
  }

  Future<void> initPusher() async {
    try {
      await pusher.init(
        apiKey: 'd5fd77d76a7a6d1ab8f4',
        cluster: 'eu',
        onMemberAdded: (String channelName, PusherMember member) {
          log("onMemberAdded: $channelName user: $member");
        },
        onSubscriptionSucceeded: (String channelName, dynamic data) {
          log("onSubscriptionSucceeded: $channelName data: $data");
        },
        onEvent: (PusherEvent event) {
          if (event.eventName == "newMessage") {
            _onNewMessageReceived(event.data);
          }
        },
        onSubscriptionError: (String message, dynamic e) {
          log("onSubscriptionError: $message Exception: $e");
        },
        onDecryptionFailure: (String event, String reason) {
          log("onDecryptionFailure: $event reason: $reason");
        },
        onConnectionStateChange: (dynamic currentState, dynamic previousState) {
          log("Connection: $currentState");
        },
        onError: (String message, int? code, dynamic e) {
          log("onError: $message code: $code exception: $e");
        },
      );
      await pusher.subscribe(channelName: 'clinic');
      await pusher.connect();
      _pusherInitialized = true;
    } catch (e) {
      log("Pusher initialization error: $e");
    }
  }

  void _onNewMessageReceived(dynamic data) async {
    await context.read<ReservationCubit>().getAdminAllConversations();
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    context.read<ReservationCubit>().getAdminAllConversations();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppColor.primaryBlue,
      child: BlocConsumer<ReservationCubit, ReservationState>(
        listener: (context, state) {
          if (state is GetAllConversationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load conversations.')),
            );
          }
        },
        builder: (context, state) {
          final List<ConversationsModel> allConversations =
              ReservationCubit.get(context).allConversations;

          if (allConversations.isEmpty) {
            return Center(
              child: Text(
                'لا توجد محادثات متاحة',
                style: AppTextStyle.font16primaryBlue600,
              ),
            );
          }

          return SizedBox(
            height: 650.h,
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 60.h, top: 50.h),
              shrinkWrap: true,
              itemBuilder: (context, index) => WaitingEmergencyChatCard(
                allConversations: allConversations,
                index: index,
              ),
              separatorBuilder: (context, index) => 12.hs,
              itemCount: allConversations.length,
            ),
          );
        },
      ),
    );
  }
}