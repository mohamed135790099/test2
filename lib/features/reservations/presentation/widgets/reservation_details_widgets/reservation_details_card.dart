import 'dart:developer';
import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_shadows.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/one_reservation.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/reservation_details_card_item.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/update_reservation.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_route_name.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/data/model/failure.dart';
import '../../../../../core/widgets/components/app_toaster.dart';
import '../../../../../core/widgets/components/error_app_toaster.dart';
import '../../../data/models/get_user_details.dart';
import '../../manager/state.dart';

class ReservationDetailsCard extends StatefulWidget {
  OneReservation? oneReservation;

  ReservationDetailsCard({super.key, required this.oneReservation});

  @override
  _ReservationDetailsCardState createState() => _ReservationDetailsCardState();
}

class _ReservationDetailsCardState extends State<ReservationDetailsCard> {
  final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final TextEditingController _reservationDiscountTextEditingController = TextEditingController();
  final TextEditingController _amountPaidController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool _isLoading = false;
  bool enable = false;
  late bool _isPaid;


  double discount=0.0;
  double discountAmount=0.0;

  double amount=0.0;
  double amountPaid=0.0;


  @override
  void initState() {
    super.initState();
    _isPaid = bool.parse(widget.oneReservation?.paid ?? "false");
    _reservationDiscountTextEditingController.addListener(updateReservationDiscount);
    _amountPaidController.addListener(updateReservationAmount);
  }

  void updateReservationDiscount(){
    String discountText = _reservationDiscountTextEditingController.text;
    if (discountText.isNotEmpty && _isNumeric(discountText)) {
      double amountByDouble = double.parse(discountText);
      setState(() {
        enable = _reservationDiscountTextEditingController.text.isNotEmpty;
        discount= amountByDouble;
      });

    }
  }

  void updateReservationAmount() {
    String amountText = _amountPaidController.text;
    if (amountText.isNotEmpty && _isNumeric(amountText)) {
      double amountByDouble = double.parse(amountText);
      setState(() {
        enable = _amountPaidController.text.isNotEmpty;
        amount= amountByDouble;
      });
    }
  }


  bool _isNumeric(String str) {
    if (str.isEmpty) return false;
    final number = double.tryParse(str);
    return number != null;
  }

  void _updatePaidStatus(bool newValue) async {
    setState(() {
      _isLoading = true;
    });

    await context.read<ReservationCubit>().updatePaidStatus(
      widget.oneReservation?.sId ?? "",
      newValue,
    );

    setState(() {
      _isPaid = newValue;
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }


  void _confirmReservation() async {
    setState(() {
      _isLoading = true;
    });

    await ReservationCubit.get(context).confirmReservations(widget.oneReservation?.sId ?? "");

    setState(() {
      _isLoading = false;
    });

    RouterApp.pushNamedAndRemoveUntil(RouteName.mainScreen);
  }

  void _amountPaid() async {
    setState(() {
      _isLoading = true;
    });

    final result = await ReservationCubit.get(context).amountPaid(
        widget.oneReservation?.sId ?? "", amount,

    );

    result.fold(
          (reservation) {
        setState(() {
          amountPaid = reservation.amountPaid?.toDouble() ?? 0.0;
        });
      },
          (failure) {
        log(failure.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
    );

    setState(() {
      _isLoading = false;
    });

    _reservationDiscountTextEditingController.clear();
  }
  void _confirmDiscountReservation() async {
    setState(() {
      _isLoading = true;
    });

    final result = await ReservationCubit.get(context).reservationsApplyDiscount(
      widget.oneReservation?.sId ?? "",
      discount,
    );

    result.fold(
          (reservation) {
        setState(() {
          discountAmount = reservation.totalPrice?.toDouble() ?? 0.0;

        });
      },
          (failure) {
        log(failure.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
    );

    setState(() {
      _isLoading = false;
    });

    _amountPaidController.clear();
  }


  @override
  Widget build(BuildContext context) {
    String patientId = widget.oneReservation?.user?.sId ?? "000000000000000";
    String patientNum = patientId.substring(0, 8);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      width: 335.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppShadows.shadow2,
        color: AppColor.white,
      ),
      child: Column(
        children: [
          ReservationDetailsCardItem(
            title: AppStrings.patientId,
            widget: Text(
              patientNum,
              style: AppTextStyle.font12black700,
            ),
          ),
          9.hs,
          ReservationDetailsCardItem(
            title: AppStrings.patientName,
            widget: Text(
              "${widget.oneReservation?.user?.fullName}",
              style: AppTextStyle.font12black700,
            ),
          ),
          9.hs,
          ReservationDetailsCardItem(
            title: AppStrings.reservationStatus,
            widget: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                color: AppColor.white2,
                border: Border(right: BorderSide(color: AppColor.primaryBlue)),
              ),
              child: widget.oneReservation?.status == "canceled"
                  ? Column(
                children: [
                  Text(AppStrings.reservationIsCanceled),
                  Text(
                    widget.oneReservation?.eventCreater == "admin"
                        ? "هذا الحجز ملغي بواسطة الطبيب."
                        : "هذا الحجز ملغي بواسطة المريض.",
                    style: AppTextStyle.font12red500,
                  ),
                ],
              )
                  : Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text: (discountAmount == null || discountAmount == 0.0)?"${widget.oneReservation?.totalPrice}":"$discountAmount",
                      style: AppTextStyle.font8primaryBlue700,
                      children: [
                        TextSpan(
                          text:
                          "${AppStrings.egp} ${_isPaid ? "مدفوعة بالعيادة" : "غير مدفوع حاليا"} ",
                          style: AppTextStyle.font8black400,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 60.w),
                  Text(
                    (amountPaid == null || amountPaid == 0.0) ? "${widget.oneReservation?.amountPaid}" : "$amountPaid",
                    style: AppTextStyle.font14black400,
                  ),
                  /*  Checkbox(
                    value: _isPaid,
                    activeColor: AppColor.primaryBlue,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        _updatePaidStatus(newValue);
                      }
                    },
                  ),*/
                ],
              ),
            ),
          ),
          12.hs,
          ReservationDetailsCardItem(
            title: AppStrings.reservationDate,
            widget: Text(
              "${widget.oneReservation?.date}",
              style: AppTextStyle.font12black700,
            ),
          ),
          12.hs,
          ReservationDetailsCardItem(
            title: AppStrings.reservationTime,
            widget: Text(
              "${widget.oneReservation?.time}",
              style: AppTextStyle.font12black700,
            ),
          ),
          12.hs,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center, // تأكد أن المحاذاة الرأسية صحيحة
            children: [
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.center, // محاذاة العنصر داخليًا
                  child: AppTextField(
                    keyboardType: TextInputType.number,
                    radius: 8.r,
                    hintText: "المبلغ المدفوع",
                    controller: _amountPaidController,
                  ),
                ),
              ),
              14.ws,
              Flexible(
                flex: 1,
                child: Padding(
                  padding:EdgeInsets.only(top:20.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: AppButton3(
                      isValid: true,
                      title: AppStrings.add,
                      onPressed: _amountPaid,
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center, // تأكد أن المحاذاة الرأسية صحيحة
            children: [
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.center, // محاذاة العنصر داخليًا
                  child: AppTextField(
                    keyboardType: TextInputType.number,
                    radius: 8.r,
                    hintText: "مبلغ الخصم(%)",
                    controller: _reservationDiscountTextEditingController,
                  ),
                ),
              ),
              14.ws,
              Flexible(
                flex: 1,
                child: Padding(
                  padding:EdgeInsets.only(top:20.h),
                  child: Align(
                    alignment: Alignment.center, // محاذاة العنصر داخليًا
                    child: AppButton3(
                      isValid: enable,
                      title: AppStrings.add,
                      onPressed: _confirmDiscountReservation,
                    ),
                  ),
                ),
              )
            ],
          ),
          16.hs,
          widget.oneReservation?.status == "confirmed" ||
              widget.oneReservation?.status == "canceled"
              ? const SizedBox()
              : _isLoading
              ? const CircularProgressIndicator()
              : Row(
            children: [
              Expanded(
                flex: 3,
                child: AppButton3(
                  isValid: widget.oneReservation?.date == currentDate
                      ? true
                      : false,
                  title: AppStrings.endReservation,
                  onPressed: _confirmReservation,
                ),
              ),
              10.ws,
              Expanded(
                flex: 3,
                child: AppButton3(
                  isValid: widget.oneReservation?.date == currentDate
                      ? true
                      : false,
                  title: AppStrings.addAdditionalService,
                  onPressed: _addAdditionalServices,
                ),
              )
            ],
          ),
          12.hs,
          /// button of Electronic Prescription
          // AppButton1(
          //     title: AppStrings.uploadElectricPrescription,
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) =>
          //                   UploadElectricPrescription(patientId: patientId)));
          //     }),
          // 18.hs,
          widget.oneReservation?.status == "confirmed" ||
              widget.oneReservation?.status == "canceled"
              ? const SizedBox()
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  ReservationCubit.get(context)
                      .cancelReservations(
                      widget.oneReservation?.sId ?? "").then((value) =>
                      RouterApp.pushNamedAndRemoveUntil(RouteName.mainScreen,));
                },
                child: Text(
                  AppStrings.closeReservation,
                  style: AppTextStyle.font12red500,
                ),
              ),
              12.ws,
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => UpdateReservation(
                      id: widget.oneReservation?.sId ?? "",
                    ),
                  );
                },
                child: Text(
                  AppStrings.postponeReservation,
                  style: AppTextStyle.font12grey3500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  void _addAdditionalServices() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: BlocListener<ReservationCubit, ReservationState>(
                  listener: (context, state) {
                    if (state is AddServiceSuccess) {
                      Navigator.pop(context);
                      AppToaster.show(state.message);
                    } else if (state is AddServiceError) {
                      ErrorAppToaster.show(state.errorMessage);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.addAdditionalService,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.font18black700,
                        ),
                        16.hs,
                        AppTextField(
                          keyboardType: TextInputType.text,
                          radius: 8.r,
                          labelText: AppStrings.title,
                          controller: titleController,
                        ),
                        16.hs,
                        AppTextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          radius: 8.r,
                          labelText: AppStrings.price,
                        ),
                        16.hs,
                        BlocBuilder<ReservationCubit, ReservationState>(
                          builder: (context, state) {
                            if (state is AddServiceLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.primaryBlue,
                                ),
                              );
                            } else {
                              return AppButton3(
                                title: AppStrings.addAdditionalService,
                                isValid: titleController.text.isNotEmpty &&
                                    priceController.text.isNotEmpty,
                                onPressed: () {
                                  final title = titleController.text;
                                  final price =
                                      int.tryParse(priceController.text) ?? 0;

                                  if (title.isNotEmpty && price > 0) {
                                    context.read<ReservationCubit>().addAdditionalServices(
                                      widget.oneReservation?.sId ?? "",
                                      {"price": price, "name": title},
                                    );
                                    titleController.text = '';
                                    priceController.text = '';
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ), // Replace with your widget
              ),
            );
          },
        );
      },
    );
  }
}
