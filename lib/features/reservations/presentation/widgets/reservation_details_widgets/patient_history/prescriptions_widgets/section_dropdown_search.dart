import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionDropDownSearch extends StatefulWidget {
  const SectionDropDownSearch({super.key});

  @override
  State<SectionDropDownSearch> createState() => _SectionDropDownSearchState();
}

class _SectionDropDownSearchState extends State<SectionDropDownSearch> {
  List sectionList = [
    'أمراض جلدية',
    'أمراض تنفسية',
    'أمراض باطنية',
    'أمراض قلب',
    'أمراض اعصاب',
  ];
  String itemSelected = '';

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<dynamic>(
      validator: (value) => itemSelected.isEmpty ? 'field required' : null,
      items: sectionList,
      onChanged: (value) {
        setState(() {
          itemSelected = value.toString();
        });
      },
      popupProps: const PopupProps.menu(
        fit: FlexFit.loose,
        showSearchBox: true,
      ),
      dropdownButtonProps: const DropdownButtonProps(isVisible: true),
      dropdownDecoratorProps: DropDownDecoratorProps(
        textAlignVertical: TextAlignVertical.center,
        dropdownSearchDecoration: InputDecoration(
            filled: true,
            fillColor: AppColor.grey,
            contentPadding:
                EdgeInsets.only(right: 12.w, top: 12.h, bottom: 12.h),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            )),
      ),
      selectedItem: itemSelected,
    );
  }
}
