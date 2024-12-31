import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/service_model.dart';

abstract class DoctorAdditionsState {}

class InitState extends DoctorAdditionsState {}

class UploadLoadingState extends DoctorAdditionsState {}

class UploadSuccessState extends DoctorAdditionsState {}

class UploadErrorState extends DoctorAdditionsState {
  final String error;

  UploadErrorState(this.error);
}

class AdsLoadingState extends DoctorAdditionsState {}

class AdsSuccessState extends DoctorAdditionsState {
  final List<dynamic> ads;

  AdsSuccessState(this.ads);
}

class AdsErrorState extends DoctorAdditionsState {
  final String error;

  AdsErrorState(this.error);
}

class DeleteAdLoading extends DoctorAdditionsState {}

class DeleteAdSuccess extends DoctorAdditionsState {}

class DeleteAdError extends DoctorAdditionsState {
  final String error;

  DeleteAdError(this.error);
}

class AddServiceLoading extends DoctorAdditionsState {}

class AddServiceSuccess extends DoctorAdditionsState {
  final String message;

  AddServiceSuccess(this.message);
}

class AddServiceFailure extends DoctorAdditionsState {
  final String error;

  AddServiceFailure(this.error);
}

class GetServiceLoading extends DoctorAdditionsState {}

class GetServiceSuccess extends DoctorAdditionsState {
  final List<Service> services;

  GetServiceSuccess(this.services);

  @override
  List<Object?> get props => [services];
}

class GetServiceError extends DoctorAdditionsState {
  final String errorMessage;

  GetServiceError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class DeleteServiceLoading extends DoctorAdditionsState {}

class DeleteServiceSuccess extends DoctorAdditionsState {
  final String message;

  DeleteServiceSuccess(this.message);
}

class DeleteServiceFailure extends DoctorAdditionsState {
  final String error;

  DeleteServiceFailure(this.error);
}

class EditServiceLoading extends DoctorAdditionsState {}

class EditServiceSuccess extends DoctorAdditionsState {}

class EditServiceError extends DoctorAdditionsState {
  final String error;

  EditServiceError(this.error);
}

class AddServicesScreenState extends DoctorAdditionsState {
  final Service? selectedService;

  AddServicesScreenState({this.selectedService});
}

class AddReservationsOfHourLoading extends DoctorAdditionsState {}

class AddReservationsOfHourSuccess extends DoctorAdditionsState {}

class AddReservationsOfHourError extends DoctorAdditionsState {
  final String error;

  AddReservationsOfHourError(this.error);
}
