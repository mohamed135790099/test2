import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFormField extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;
  final dynamic onChanged;

  const SearchFormField(
      {super.key,
      required this.searchController,
      this.onChanged,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      radius: 8.r,
      controller: searchController,
      onChanged: onChanged,
      hintText: hintText,
      fixIcon: AppImageView(
        svgPath: Assets.svgSearch,
        height: 24.h,
        width: 24.w,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
