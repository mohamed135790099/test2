import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/features/emergency/presentation/widgets/emergency_chat/patient_dropdownsearch_by_id.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNewChatBottomSheet extends StatelessWidget {
  const AddNewChatBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 300.h,
      child: Column(
        children: [
          Text(
            'Start a New Chat',
            style: AppTextStyle.font14primaryBlue500,
          ),
          60.hs,
          const PatientDropDownSearchById(),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: AppButton3(
              title: 'بدء دردشة',
              isValid: true, // Adjust validation logic as needed
              onPressed: () async {
                final reservationCubit = ReservationCubit.get(context);
                final patientId = reservationCubit.patientId;
                if (patientId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('من فضلك اختر مريض')),
                  );
                  return;
                }

                try {
                  Navigator.pushNamed(
                    context,
                    '/emergencyChatDetailsScreen',
                    arguments: {
                      'receiverId': patientId,
                    },
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to start chat')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
