import 'package:dr_mohamed_salah_admin/features/reservations/data/models/last_reservation_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/latest_reservation_widgets/latest_reservation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../data/models/get_user_details.dart';
import '../../../../data/models/one_reservation.dart';

class LatestReservationList extends StatefulWidget {
  final String? id;
  final String? date;
  OneReservation? reservation;
  UserModel? reservationModel;

  LatestReservationList({super.key, this.id, this.date, this.reservation, this.reservationModel});

  @override
  State<LatestReservationList> createState() => _LatestReservationListState();
}

class _LatestReservationListState extends State<LatestReservationList> {
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        if (state is GetLastReservationsSuccess) {
          final List<Reservation> userLastReservations = state.reservations;

          return SizedBox(
            height: 500.h,
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 250.h, top: 20.h),
              shrinkWrap: true,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => PatientDetails(
                      index:index ,
                      reservation: widget.reservation ,
                      reservationModel:  widget.reservationModel,
                    ),
                  );
                },
                child: LatestReservationCard(
                  lastReservations: userLastReservations,
                  index: index,
                ),
              ),
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemCount: userLastReservations.length,
            ),
          );
        } else if (state is GetLastReservationsError) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: SizedBox());
        }
      },
    );
  }

  Future<void> initializeData() async {
    await context.read<ReservationCubit>().getLastUserReservations(widget.id ?? "", widget.date ?? "");
  }
}

class PatientDetails extends StatelessWidget {
  final OneReservation? reservation;
  UserModel? reservationModel;
  final int index;

  PatientDetails({super.key, this.reservation, this.reservationModel,required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'فاتورة المريض',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'التاريخ: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'رقم الفاتورة: #${reservation?.sId ?? reservationModel?.sId ?? 'غير متوفر'}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('اسم المريض:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text(reservation?.user?.fullName ?? reservationModel?.fullName ?? 'غير متوفر'),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('سعر الكشف:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text('${reservation?.examinationPrice ?? reservationModel!.reservs?[index].examinationPrice ?? 0} جنيه'),
              ],
            ),
            const SizedBox(height: 10),
            if ((reservation?.additionalServices?.isNotEmpty ?? false) || (reservationModel?.reservs?[index].additionalServices?.isNotEmpty ?? false)) ...[
              const Text(
                'الخدمات الإضافية:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(reservation?.additionalServices?.isNotEmpty ?? false)
                  ? reservation!.additionalServices!.map((service) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(service.name ?? 'غير معروف'),
                      Text('${service.price ?? 0} جنيه'),
                    ],
                  ),
                );
              }).toList()
                  : (reservationModel!.reservs?[index].additionalServices ?? []).map((service) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(service.name ?? 'غير معروف'),
                      Text('${service.price ?? 0} جنيه'),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 10),
            ],
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('قيمة الخصم :', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text('${reservation?.discount ?? reservationModel?.reservs?[index].discount ?? 0} %'),
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('السعر الإجمالي:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text('${reservation?.totalPrice ?? reservationModel?.reservs?[index].totalPrice ?? 0} جنيه'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('المبلغ المدفوع:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text('${reservation?.amountPaid ?? reservationModel?.reservs?[index].amountPaid ?? 0} جنيه'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('متبقي :', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text('${reservation?.remainingAmount ?? reservationModel?.reservs?[index].remainingAmount ?? 0}جنية'),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 2),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}





