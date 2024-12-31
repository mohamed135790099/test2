import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_2.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/all_filtered_resciepts_widgets/filter_by_day_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllFilteredReceipts extends StatefulWidget {
  const AllFilteredReceipts({super.key});

  @override
  State<AllFilteredReceipts> createState() => _AllFilteredReceiptsState();
}

class _AllFilteredReceiptsState extends State<AllFilteredReceipts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar2(
        title: "عرض الفواتير",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: ListView(
          children: [
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlueTransparent2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "عرض الفواتير لفترة معينة",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 35.h),
            const FilterReceiptsBySpecificDurationList(),
          ],
        ),
      ),
    );
  }
}
