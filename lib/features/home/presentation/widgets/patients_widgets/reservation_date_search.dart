import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class ReservationTimeSearch extends StatefulWidget {
  final List<String> times;
  final Function(String) onTimeSelected;

  const ReservationTimeSearch({
    super.key,
    required this.times,
    required this.onTimeSelected,
  });

  @override
  State<ReservationTimeSearch> createState() => _ReservationTimeSearchState();
}

class _ReservationTimeSearchState extends State<ReservationTimeSearch> {
  String itemSelected = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.reservationTime,
          style: AppTextStyle.font14black500,
        ),
        10.hs,
        DropdownSearch<String>(
          validator: (value) =>
              value?.isEmpty ?? false ? 'field required' : null,
          itemAsString: (year) => year.toString(),
          items: widget.times,
          onChanged: (value) {
            if (value != null) {
              widget.onTimeSelected(value);
            }
          },
          popupProps: PopupProps.menu(
            fit: FlexFit.loose,
            showSelectedItems: true,
            itemBuilder: (context, item, isSelected) {
              return ListTile(
                title: Text(item),
                selected: isSelected,
              );
            },
          ),
        ),
      ],
    );
  }
}
