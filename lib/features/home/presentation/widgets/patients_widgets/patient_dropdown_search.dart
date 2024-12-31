import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/auth/data/models/get_all_users.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientDropDownSearch extends StatefulWidget {
  const PatientDropDownSearch({super.key});

  @override
  State<PatientDropDownSearch> createState() => _PatientDropDownSearchState();
}

class _PatientDropDownSearchState extends State<PatientDropDownSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final ReservationCubit reservationCubit = ReservationCubit.get(context);
        final List<GetAllUsers> patientNames = reservationCubit.allUsers;
        return DropdownSearch<GetAllUsers>(
          validator: (value) =>
              value?.fullName?.isEmpty ?? false ? 'field required' : null,
          items: patientNames,
          onChanged: reservationCubit.setPickModel,
          selectedItem: null,
          popupProps:
              const PopupProps.menu(fit: FlexFit.loose, showSearchBox: true),
          dropdownButtonProps: const DropdownButtonProps(isVisible: false),
          dropdownDecoratorProps: DropDownDecoratorProps(
            textAlignVertical: TextAlignVertical.center,
            dropdownSearchDecoration: InputDecoration(
                hintText: 'Select a patient',
                filled: true,
                fillColor: AppColor.grey,
                contentPadding:
                    EdgeInsets.only(right: 12.w, top: 12.h, bottom: 12.h),
                suffix: AppImageView(
                  svgPath: Assets.svgDropdownSearch,
                  height: 24.h,
                  width: 24.w,
                  fit: BoxFit.scaleDown,
                ),
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.primaryBlue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                )),
          ),
          itemAsString: (allUsers) => allUsers.fullName ?? '',
          filterFn: (allUsers, filter) =>
              allUsers.fullName!.toLowerCase().contains(filter.toLowerCase()),
          compareFn: (allUsers, filter) => allUsers.fullName == filter.fullName,
        );
      },
    );
  }
}
