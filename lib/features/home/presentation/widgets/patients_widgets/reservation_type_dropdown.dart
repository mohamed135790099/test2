import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/service_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationTypeDropDown extends StatefulWidget {
  const ReservationTypeDropDown({super.key});

  @override
  State<ReservationTypeDropDown> createState() =>
      _ReservationTypeDropDownState();
}

class _ReservationTypeDropDownState extends State<ReservationTypeDropDown> {
  List<Service> serviceList = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    final cubit = ReservationCubit.get(context);
    try {
      await cubit.fetchAllServices();
      setState(() {
        serviceList = cubit.services;
      });
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final reservationCubit = ReservationCubit.get(context);
        return DropdownSearch<Service>(
          validator: (value) => value == null ? 'field required' : null,
          items: serviceList,
          itemAsString: (Service service) => service.name ?? '',
          // Show the service name
          onChanged: (Service? selectedService) {
            if (selectedService != null) {
              reservationCubit.setReservationType(selectedService.name!);
              reservationCubit.setReservationPrice(
                  selectedService.price!.toString()); // Set price in cubit
            }
          },
          popupProps: const PopupProps.menu(
            fit: FlexFit.loose,
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
              ),
            ),
          ),
        );
      },
    );
  }
}
