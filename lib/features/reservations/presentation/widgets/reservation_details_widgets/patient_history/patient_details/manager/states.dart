import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/patient_details/patient_history.dart';
import 'package:equatable/equatable.dart';

abstract class PatientHistoryState extends Equatable {
  const PatientHistoryState();

  @override
  List<Object?> get props => [];
}

class PatientHistoryInitial extends PatientHistoryState {}

class PatientHistoryLoading extends PatientHistoryState {}

class PatientHistoryLoaded extends PatientHistoryState {
  final PatientHistory patientHistory;

  const PatientHistoryLoaded(this.patientHistory);

  @override
  List<Object?> get props => [patientHistory];
}

class PatientHistoryUpdated extends PatientHistoryState {
  final String message;

  const PatientHistoryUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class PatientHistoryError extends PatientHistoryState {
  final String message;

  const PatientHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
