import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_shadows.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/data/models/conversations_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_route_name.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class WaitingEmergencyChatCard extends StatelessWidget {
  final List<ConversationsModel>? allConversations;
  final int index;

  const WaitingEmergencyChatCard({
    super.key,
    required this.allConversations,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (index < 0 || index >= allConversations!.length) {
      return const SizedBox.shrink();
    }

    final conversation = allConversations![index];
    final participants = conversation.participants ?? [];

    if (participants.isEmpty) {
      return const SizedBox.shrink();
    }

    final participant = participants.isNotEmpty ? participants[0] : null;
    if (participant == null) {
      return const SizedBox.shrink();
    }

    DateTime dateTime =
        DateTime.parse(conversation.lastMessage?.createdAt ?? "");
    var formatter = DateFormat.jm('ar');
    String formattedTime = formatter.format(dateTime);

    var formatterDate = DateFormat.yMMMMd('ar');
    String formattedDate = formatterDate.format(dateTime);

    bool isUnread = conversation.lastMessage != null &&
        conversation.lastMessage!.senderModel == "user" &&
        conversation.lastMessage!.isRead == false;

    return InkWell(
      onTap: () {
        ReservationCubit.get(context)
            .getConversationMessages(conversation.sId ?? "")
            .then((value) => RouterApp.pushNamed(
                  RouteName.emergencyChatDetailsScreen,
                  arguments: conversation.sId,
                ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        width: 335.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppShadows.shadow2,
          color: AppColor.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  participant.fullName ?? "Unknown Patient",
                  style: AppTextStyle.font16black700,
                ),
                const Spacer(),
                isUnread
                    ? Container(
                        margin: const EdgeInsetsDirectional.all(6),
                        child: const Icon(Icons.markunread,
                            color: Colors.red, size: 28))
                    : AppImageView(
                        svgPath: Assets.svgArrow,
                        height: 12.h,
                        width: 12.w,
                        fit: BoxFit.scaleDown,
                      ),
              ],
            ),
            6.hs,
            Container(
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 8),
              child: Text(
                conversation.lastMessage?.message ?? "",
                style: AppTextStyle.font16black400,
              ),
            ),
            6.hs,
            Row(
              children: [
                AppImageView(
                  svgPath: Assets.svgClock,
                  height: 14.h,
                  width: 14.w,
                  fit: BoxFit.scaleDown,
                ),
                10.ws,
                Text(
                  formattedTime,
                  style: AppTextStyle.font12grey5400,
                ),
                8.ws,
                AppImageView(
                  svgPath: Assets.svgCalendar,
                  height: 14.h,
                  width: 14.w,
                  fit: BoxFit.scaleDown,
                ),
                10.ws,
                Text(
                  formattedDate,
                  style: AppTextStyle.font12grey5400,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
