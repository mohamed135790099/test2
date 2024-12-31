import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/data/models/message_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmergencyChatUserCard extends StatelessWidget {
  final List<MessageHistoryModel> messages;
  final int index;
  final String dateTime;

  const EmergencyChatUserCard({
    super.key,
    required this.messages,
    required this.index,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 150.w),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            decoration: const BoxDecoration(
              color: AppColor.redTransparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messages[index].message ?? "",
                  style: AppTextStyle.font12black400,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dateTime,
                    style: AppTextStyle.font12black400,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
