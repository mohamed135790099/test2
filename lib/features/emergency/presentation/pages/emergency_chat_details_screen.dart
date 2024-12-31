import 'dart:convert';
import 'dart:developer';

import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_app_bar_chat.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/message_form_field.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/data/models/message_history_model.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/presentation/widgets/emergency_chat/emergency_chat_admin_card.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/presentation/widgets/emergency_chat/emergency_chat_user_card.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class EmergencyChatDetailsScreen extends StatefulWidget {
  const EmergencyChatDetailsScreen({super.key});

  @override
  State<EmergencyChatDetailsScreen> createState() =>
      _EmergencyChatDetailsScreenState();
}

class _EmergencyChatDetailsScreenState
    extends State<EmergencyChatDetailsScreen> {
  TextEditingController messageController = TextEditingController();
  List<MessageHistoryModel> messages = [];
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  bool _pusherInitialized = false;
  final ScrollController _scrollController = ScrollController();
  String currentVisibleDate = "";
  String? userId;

  void initPusher() async {
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
            handleMessageEvent(event.data);
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

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    userId = ReservationCubit.get(context).getUserDetail?.sId;
    messages = ReservationCubit.get(context).allMessages;
    if (!_pusherInitialized) {
      initPusher();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void handleMessageEvent(String eventData) {
    try {
      final jsonData = jsonDecode(eventData);
      final conversation = jsonData['conversation'];
      if (messages.isNotEmpty && conversation == messages[0].conversation) {
        setState(() {
          messages.add(MessageHistoryModel.fromJson(jsonData));
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    } catch (e) {
      log("Error processing event data: $e");
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() async {
    if (messages.isNotEmpty && messageController.text.isNotEmpty) {
      final messageContent = messageController.text;
      final receiverId = messages[0].receiverModel == "user"
          ? messages[0].receiver?.sId
          : messages[0].sender?.sId;

      ReservationCubit.get(context).sendMessage(receiverId, messageContent);
      messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    pusher.unsubscribe(channelName: 'clinic');
    pusher.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiverId = messages[0].receiverModel == "user"
        ? messages[0].receiver?.sId
        : messages[0].sender?.sId;
    final receiverModel = messages.isNotEmpty ? messages[0].receiverModel : '';
    final receiverName = receiverModel == "user"
        ? messages.isNotEmpty && messages[0].receiver?.fullName != null
            ? messages[0].receiver!.fullName!
            : 'Unknown User'
        : messages.isNotEmpty && messages[0].sender?.fullName != null
            ? messages[0].sender!.fullName!
            : 'Unknown Admin';

    return Scaffold(
      appBar: DefaultAppBarChat(title: receiverName, id: receiverId),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: MessageFormField(
              messageController: messageController,
              onPressed: sendMessage,
            ),
          ),
        ],
      ).withHorizontalPadding(20).withVerticalPadding(10),
      body: SizedBox(
        height: 700.h,
        child: Stack(
          children: [
            Positioned(
              right: 110.w,
              left: 110.w,
              child: Container(
                padding: const EdgeInsetsDirectional.all(8),
                decoration: BoxDecoration(
                  color: AppColor.grey3,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    currentVisibleDate.isNotEmpty
                        ? currentVisibleDate
                        : 'No Date',
                    style: AppTextStyle.font12black400,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsetsDirectional.only(top: 60.h),
              child: ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    top: 20.h, right: 20.w, left: 20.w, bottom: 10.h),
                itemBuilder: (context, index) {
                  if (index < 0 || index >= messages.length) {
                    return const SizedBox();
                  }
                  final DateTime dateTime =
                      DateTime.parse(messages[index].createdAt!);
                  var formatter = DateFormat.jm('ar');
                  String formattedTime = formatter.format(dateTime);

                  var formatterDate = DateFormat.yMMMMd('ar');
                  String formattedDate = formatterDate.format(dateTime);

                  return VisibilityDetector(
                    key: Key(index.toString()),
                    onVisibilityChanged: (visibilityInfo) {
                      if (visibilityInfo.visibleFraction > 0.5) {
                        setState(() {
                          currentVisibleDate = formattedDate;
                        });
                      }
                    },
                    child: messages[index].senderModel == "user"
                        ? EmergencyChatUserCard(
                            messages: messages,
                            index: index,
                            dateTime: formattedTime,
                          )
                        : EmergencyChatAdminCard(
                            messages: messages,
                            index: index,
                            dateTime: formattedTime,
                          ),
                  );
                },
                separatorBuilder: (context, index) => 12.hs,
                itemCount: messages.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
