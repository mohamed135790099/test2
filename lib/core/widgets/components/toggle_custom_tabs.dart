import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/style/app_color.dart';
import '../../../config/style/text_styles.dart';

class ToggleCustomTabs extends StatefulWidget implements PreferredSizeWidget {
  final Function(int index)? onIndexChange;
  final List<String> tabs;
  final int currentIndex;
  final bool isScroll;

  const ToggleCustomTabs(
      {super.key,
      this.onIndexChange,
      required this.tabs,
      this.currentIndex = 0,
      this.isScroll = false});

  @override
  State<ToggleCustomTabs> createState() => _ToggleCustomTabsState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 50.h);
}

class _ToggleCustomTabsState extends State<ToggleCustomTabs> {
  int _index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _index = widget.currentIndex;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      initialIndex: _index,
      child: _tabsBuild(),
    );
  }

  Widget _tabsBuild() => SizedBox(
        height: 50.h,
        width: double.infinity,
        child: TabBar(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            color: AppColor.primaryBlue,
          ),
          isScrollable: widget.isScroll,
          padding: EdgeInsetsDirectional.zero,
          indicatorPadding: EdgeInsets.zero,
          tabAlignment:
              widget.isScroll ? TabAlignment.start : TabAlignment.fill,
          indicatorWeight: 2,
          indicatorColor: AppColor.primaryBlue,
          labelPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (i) {
            setState(() {
              _index = i;
            });
            if (widget.onIndexChange != null) {
              widget.onIndexChange!(_index);
            }
          },
          labelColor: AppColor.white,
          labelStyle: AppTextStyle.font12white400,
          unselectedLabelStyle: AppTextStyle.font12grey2400,
          unselectedLabelColor: AppColor.grey2,
          tabs: widget.tabs
              .map<Widget>((e) => Tab(
                    text: e,
                  ).withHorizontalPadding(widget.isScroll ? 20 : 0))
              .toList(),
        ),
      );
}
