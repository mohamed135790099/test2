import 'package:dr_mohamed_salah_admin/core/data/model/failure.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/service_model.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/last_reservation_model.dart';

import '../../../home/data/model/new_reservation_model.dart';
import '../../data/models/get_user_details.dart';

abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class AddServiceLoading extends ReservationState {}

class AddServiceSuccess extends ReservationState {
  final String message;

  AddServiceSuccess(this.message);
}

class AddServiceError extends ReservationState {
  final String errorMessage;

  AddServiceError(this.errorMessage);
}

class ServiceLoading extends ReservationState {}

class ServiceSuccess extends ReservationState {
  List<Service> services;

  ServiceSuccess(this.services);
}

class ServiceError extends ReservationState {
  final String error;

  ServiceError(this.error);
}

class DeleteAnalysisLoading extends ReservationState {}

class DeleteAnalysisSuccess extends ReservationState {}

class DeleteAnalysisError extends ReservationState {
  final String error;

  DeleteAnalysisError(this.error);
}

class DeleteXRayLoading extends ReservationState {}

class DeleteXRaySuccess extends ReservationState {}

class DeleteXRayError extends ReservationState {
  final String error;

  DeleteXRayError(this.error);
}

class DeleteMedicineLoading extends ReservationState {}

class DeleteMedicineSuccess extends ReservationState {}

class DeleteMedicineError extends ReservationState {
  final String error;

  DeleteMedicineError(this.error);
}

class DeletePrescriptionLoading extends ReservationState {}

class DeletePrescriptionSuccess extends ReservationState {}

class DeletePrescriptionError extends ReservationState {
  final String error;

  DeletePrescriptionError(this.error);
}
//////////////////////////////////////

//////////////////////////////////////

class SelectedDateChanged extends ReservationState {}

class SendMessageLoading extends ReservationState {}

class SendMessageSuccess extends ReservationState {}

class SendMessageError extends ReservationState {
  final String error;

  SendMessageError(this.error);
}

////////////////////

class UpdatePatientDetailsLoading extends ReservationState {}

class UpdatePatientDetailsSuccess extends ReservationState {
  final String message;

  UpdatePatientDetailsSuccess(this.message);

  List<Object?> get props => [message];
}

class UpdatePatientDetailsError extends ReservationState {
  final String message;

  UpdatePatientDetailsError(this.message);

  List<Object?> get props => [message];
}

class GetPatientID extends ReservationState {}

// Define the states for fetching reservations by date
class GetReservationsByDateLoading extends ReservationState {}

class GetReservationsByDateSuccess extends ReservationState {}

class GetReservationsByDateError extends ReservationState {}

class ReservationSuccess extends ReservationState {}

class ReservationFailure extends ReservationState {
  final String message;

  ReservationFailure(this.message);

  List<Object?> get props => [message];
}

// Reservation loading states
class ReservationLoading extends ReservationState {}

// Available hours states
class ReservationHoursLoading extends ReservationState {}

class ReservationHoursLoaded extends ReservationState {
  final List<String> availableHours;

  ReservationHoursLoaded(this.availableHours);
}

class ReservationHoursError extends ReservationState {
  final String message;

  ReservationHoursError(this.message);
}

// Starting new Chat with patient
class StartNewChatLoading extends ReservationState {}

class StartNewChatSuccess extends ReservationState {}

class StartNewChatFailure extends ReservationState {
  final String error;

  StartNewChatFailure(this.error);
}

// Image fetching states
class GetPrescriptionImageLoading extends ReservationState {}

class GetPrescriptionImageSuccess extends ReservationState {}

class GetPrescriptionImageError extends ReservationState {}

class GetXRayImageLoading extends ReservationState {}

class GetXRayImageSuccess extends ReservationState {}

class GetXRayImageError extends ReservationState {}

class GetAnalysisImageLoading extends ReservationState {}

class GetAnalysisImageSuccess extends ReservationState {}

class GetAnalysisImageError extends ReservationState {}

class GetMedicinesImageLoading extends ReservationState {}

class GetMedicinesImageSuccess extends ReservationState {}

class GetMedicinesImageError extends ReservationState {}

// Reservation creation states
class CreateReservationLoading extends ReservationState {}

class CreateReservationSuccess extends ReservationState {}

class CreateReservationError extends ReservationState {
  String? errorMessage;

  CreateReservationError(this.errorMessage);
}

// User creation by admin states
class CreateUserByAdminLoading extends ReservationState {}

class CreateUserByAdminSuccess extends ReservationState {}

class CreateUserByAdminError extends ReservationState {
  final Failure failure;

  CreateUserByAdminError(this.failure);
}

// Reservations management states
class GetAllReservationsLoading extends ReservationState {}

class GetAllReservationsSuccess extends ReservationState {}

class GetAllReservationsError extends ReservationState {}

class GetLastReservationsLoading extends ReservationState {}

class GetLastReservationsSuccess extends ReservationState {
  final List<Reservation> reservations;

  GetLastReservationsSuccess(this.reservations);
}

class GetLastReservationsError extends ReservationState {
  final String error;

  GetLastReservationsError(this.error);
}

class GetOneReservationsLoading extends ReservationState {}

class GetOneReservationsSuccess extends ReservationState {}

class GetOneReservationsError extends ReservationState {}

class CancelReservationsLoading extends ReservationState {}

class CancelReservationsSuccess extends ReservationState {}

class CancelReservationsError extends ReservationState {}

class ConfirmReservationsLoading extends ReservationState {}

class ConfirmReservationsSuccess extends ReservationState {}

class ConfirmReservationsError extends ReservationState {}

class UpdateReservationsLoading extends ReservationState {}

class UpdateReservationsSuccess extends ReservationState {}

class UpdateReservationsError extends ReservationState {}

// Conversations states
class GetAllConversationLoading extends ReservationState {}

class GetAllConversationSuccess extends ReservationState {}

class GetAllConversationError extends ReservationState {}

class GetOneConversationLoading extends ReservationState {}

class GetOneConversationSuccess extends ReservationState {}

class GetOneConversationError extends ReservationState {}

// User reservations states
class GetUserReservationsLoading extends ReservationState {}

class GetUserReservationsSuccess extends ReservationState {}

class GetUserReservationsError extends ReservationState {}

// User names states
class GetAllUserNamesLoading extends ReservationState {}

class GetAllUserNamesSuccess extends ReservationState {}

class GetAllUserNamesError extends ReservationState {}

// User management states
class GetAllUserLoading extends ReservationState {}

class GetAllUserSuccess extends ReservationState {}

class GetAllUserError extends ReservationState {}

class GetUserDetailsLoading extends ReservationState {}

class GetUserDetailsSuccess extends ReservationState {}

class GetUserDetailsError extends ReservationState {}

// Patient name state
class GetPatientName extends ReservationState {}

class GetReservationTypeState extends ReservationState {
  final String? typeName;

  GetReservationTypeState(this.typeName);
}

class GetReservationPriceState extends ReservationState {
  final String? price;

  GetReservationPriceState(this.price);
}

//////////////////////////////////////////////////////

class CreatePrescriptionLoading extends ReservationState {}

class CreatePrescriptionSuccess extends ReservationState {}

class CreatePrescriptionError extends ReservationState {
  String error;

  CreatePrescriptionError(this.error);
}

class CreateXRayLoading extends ReservationState {}

class CreateXRaySuccess extends ReservationState {}

class CreateXRayError extends ReservationState {
  String error;

  CreateXRayError(this.error);
}

class CreateAnalysisLoading extends ReservationState {}

class CreateAnalysisSuccess extends ReservationState {}

class CreateAnalysisError extends ReservationState {
  String error;

  CreateAnalysisError(this.error);
}

class CreateMedicineLoading extends ReservationState {}

class CreateMedicineSuccess extends ReservationState {}

class CreateMedicineError extends ReservationState {
  String error;

  CreateMedicineError(this.error);
}

class AnalysisImageCleared extends ReservationState {}

class MedicineImageCleared extends ReservationState {}

class XRayImageCleared extends ReservationState {}

class PrescriptionImageCleared extends ReservationState {}

class GetXPdfFileLoading extends ReservationState {}

class GetXPdfFileSuccess extends ReservationState {}

class GetXPdfFileError extends ReservationState {}

class GetAnalysisPdfFileLoading extends ReservationState {}

class GetAnalysisPdfFileSuccess extends ReservationState {}

class GetAnalysisPdfFileError extends ReservationState {}

class UploadPdfFileLoading extends ReservationState {}

class UploadPdfFileSuccess extends ReservationState {
  final dynamic response;

  UploadPdfFileSuccess(this.response);
}

class UploadPdfFileError extends ReservationState {
  final String message;

  UploadPdfFileError(this.message);
}

////////////// Editing Medical Records in Admin
class EditPrescriptionLoading extends ReservationState {}

class EditPrescriptionSuccess extends ReservationState {}

class EditPrescriptionError extends ReservationState {
  final String error;

  EditPrescriptionError(this.error);
}

class EditMedicineLoading extends ReservationState {}

class EditMedicineSuccess extends ReservationState {}

class EditMedicineError extends ReservationState {
  final String error;

  EditMedicineError(this.error);
}

class EditAnalysisLoading extends ReservationState {}

class EditAnalysisSuccess extends ReservationState {}

class EditAnalysisError extends ReservationState {
  final String error;

  EditAnalysisError(this.error);
}

class EditXRayLoading extends ReservationState {}

class EditXRaySuccess extends ReservationState {}

class EditXRayError extends ReservationState {
  final String error;

  EditXRayError(this.error);
}

class GetOnePrescriptionSuccess extends ReservationState {}

class GetOnePrescriptionError extends ReservationState {}

class GetOnePrescriptionLoading extends ReservationState {}

class GetOneMedicineSuccess extends ReservationState {}

class GetOneMedicineError extends ReservationState {}

class GetOneMedicineLoading extends ReservationState {}

class GetOneXRaySuccess extends ReservationState {}

class GetOneXRayError extends ReservationState {}

class GetOneXRayLoading extends ReservationState {}

class GetOneAnalysisSuccess extends ReservationState {}

class GetOneAnalysisError extends ReservationState {}

class GetOneAnalysisLoading extends ReservationState {}

class EditPaidStateLoading extends ReservationState {}

class EditPaidStateSuccess extends ReservationState {}

class EditPaidStateError extends ReservationState {
  final String error;

  EditPaidStateError(this.error);
}
class DiscountValueStateLoading extends ReservationState {}

class DiscountValueStateSuccess extends ReservationState {}

class DiscountValueStateError extends ReservationState {
  final String error;

  DiscountValueStateError(this.error);
}

class AmountPaidStateLoading extends ReservationState {}

class AmountPaidStateSuccess extends ReservationState {}

class AmountPaidStateError extends ReservationState {
  final String error;

  AmountPaidStateError(this.error);
}

// Loading States
class FilteredReservationLoadingState extends ReservationState {}

class EndedReservationLoadingState extends ReservationState {}

// Success States
class FilteredReservationSuccessState extends ReservationState {
  final List<Reservations> reservations; // Replace `dynamic` with the actual model class, e.g., `Reservation`

  FilteredReservationSuccessState(this.reservations);
}

class EndedReservationSuccessState extends ReservationState {
  final List<Reservations> reservations; // Replace `dynamic` with the actual model class, e.g., `Reservation`

  EndedReservationSuccessState(this.reservations);
}

// Error States
class FilteredReservationErrorState extends ReservationState {
  final String error; // You can also use a custom error class if needed

  FilteredReservationErrorState(this.error);
}

class EndedReservationErrorState extends ReservationState {
  final String error;

  EndedReservationErrorState(this.error);
}



class EditDiscountStateError extends ReservationState {
  final String error;

  EditDiscountStateError(this.error);
}

class EditDiscountStateSuccess extends ReservationState {
  ReservationModel reservations;

  EditDiscountStateSuccess(this.reservations);
}