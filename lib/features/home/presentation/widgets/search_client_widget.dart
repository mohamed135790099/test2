import '/core/widgets/components/text_field.dart';
import '/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchNameFormField extends StatelessWidget {
  final TextEditingController nameController;
  final ValueChanged<String> onChanged;

  const SearchNameFormField({
    super.key,
    required this.nameController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      radius: 8.r,
      labelText: AppStrings.search,
      controller: nameController,
      hintText: AppStrings.pleaseEnterName,
      onChanged: onChanged, // Pass the callback here
    );
  }
}
