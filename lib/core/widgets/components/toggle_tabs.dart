import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/style/app_color.dart';
import '../../../config/style/text_styles.dart';

class ToggleTabs extends StatefulWidget implements PreferredSizeWidget {
  final Function(int index)? onIndexChange;
  final List<String> tabs;
  final int currentIndex;
  final bool isScroll;
  final bool isHome;

  const ToggleTabs(
      {super.key,
      this.onIndexChange,
      required this.tabs,
      this.currentIndex = 0,
      this.isScroll = false,
      this.isHome = false});

  @override
  State<ToggleTabs> createState() => _ToggleTabsState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 50.h);
}

class _ToggleTabsState extends State<ToggleTabs> {
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
          isScrollable: widget.isScroll,
          padding: EdgeInsetsDirectional.zero,
          indicatorPadding: EdgeInsets.zero,
          tabAlignment:
              widget.isScroll ? TabAlignment.start : TabAlignment.fill,
          indicatorWeight: 2,
          indicatorColor: _index == 1
              ? widget.isHome
                  ? AppColor.red
                  : AppColor.primaryBlue
              : AppColor.primaryBlue,
          labelPadding: EdgeInsets.zero,
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
          labelColor: AppColor.black,
          labelStyle: AppTextStyle.font16black700,
          unselectedLabelStyle: AppTextStyle.font16black400,
          unselectedLabelColor: AppColor.black,
          tabs: widget.tabs
              .map<Widget>((e) => Tab(
                    text: e,
                  ).withHorizontalPadding(widget.isScroll ? 20 : 0))
              .toList(),
        ),
      );
}
