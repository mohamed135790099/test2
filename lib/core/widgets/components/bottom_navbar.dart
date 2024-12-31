import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNavBar({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    final iconList = [
      Assets.svgHome,
      Assets.svgBookings,
      Assets.svgPatients,
      Assets.svgEmergency,
      Assets.svgMore
    ];
    final iconTitles = [
      AppStrings.home,
      AppStrings.reservations,
      AppStrings.patients,
      AppStrings.emergency,
      AppStrings.more,
    ];
    return AnimatedBottomNavigationBar.builder(
      elevation: 0.0,
      gapWidth: 0.0,
      gapLocation: GapLocation.none,
      notchMargin: 0.0,
      scaleFactor: 0.0,
      hideAnimationCurve: Curves.easeIn,
      safeAreaValues: const SafeAreaValues(bottom: false),
      height: 75.h,
      activeIndex: currentIndex,
      onTap: (int index) => onTap?.call(index),
      itemCount: 5,
      tabBuilder: (int index, bool isActive) => _bottomNavItem(
          text: iconTitles[index], icon: iconList[index], index: index),
    );
  }

  Widget _bottomNavItem(
      {required String text, required String icon, required int index}) {
    final bool isSelected = currentIndex == index;
    return Container(
      width: isSelected ? 60.w : 20.w,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color:
              isSelected ? AppColor.primaryBlueTransparent1 : AppColor.white),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isSelected
                ? FittedBox(
                    child: AppImageView(
                      svgPath: icon,
                      width: 20.w,
                      height: 20.h,
                      color: isSelected ? AppColor.primaryBlue : AppColor.grey,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(),
            4.ws,
            Text(text,
                textAlign: TextAlign.center,
                style: isSelected
                    ? AppTextStyle.font12primaryBlue400
                    : AppTextStyle.font12grey2400)
          ],
        ),
      ),
    );
  }
}
