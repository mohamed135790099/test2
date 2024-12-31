// import 'package:dr_mohamed_salah_admin/features/home/presentation/widgets/reservation_card.dart';
// import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_all_reservations.dart';
// import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
// import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
// import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/date_timeline_widget.dart';
// import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/all_filtered_reservations_widgets/total_reservations_container.dart';
// import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
//
// class FilterByDayList extends StatelessWidget {
//   const FilterByDayList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReservationCubit, ReservationState>(
//       builder: (context, state) {
//         final List<GetAllReservations> allReservations =
//             ReservationCubit.get(context).allReservations;
//         final ReservationCubit reservationCubit = ReservationCubit.get(context);
//         List<GetAllReservations> filteredByDate = allReservations
//             .where((reservation) =>
//                 reservation.date ==
//                 DateFormat('dd/MM/yyyy', "ar")
//                     .format(reservationCubit.selectedDates ?? DateTime.now()))
//             .toList();
//
//         // Sort the filtered list
//         filteredByDate.sort((a, b) => a.date!.compareTo(b.date!));
//
//         return Column(
//           children: [
//             const DateTimeline(),
//             12.hs,
//             TotalReservationsContainer(total: "${filteredByDate.length}"),
//             12.hs,
//             filteredByDate.isEmpty
//                 ? const SizedBox()
//                 : SizedBox(
//                     height: 350.h,
//                     child: ListView.separated(
//                       padding: EdgeInsets.only(bottom: 60.h),
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) => ReservationCard(
//                         index: index,
//                         sortedList: filteredByDate,
//                       ),
//                       separatorBuilder: (context, index) => 12.hs,
//                       itemCount: filteredByDate.length,
//                     ),
//                   ),
//           ],
//         );
//       },
//     );
//   }
// }
