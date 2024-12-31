import 'package:equatable/equatable.dart';

abstract class BookingTimesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingTimesInitial extends BookingTimesState {}

class BookingTimesLoading extends BookingTimesState {}

class BookingTimesSuccess extends BookingTimesState {}

class BookingTimesError extends BookingTimesState {
  final String message;

  BookingTimesError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingTimesLoaded extends BookingTimesState {
  final List<dynamic> bookingDays;

  BookingTimesLoaded(this.bookingDays);

  @override
  List<Object> get props => [bookingDays];
}

class HideScheduleLoading extends BookingTimesState {}

class HideScheduleSuccess extends BookingTimesState {}

class HideScheduleError extends BookingTimesState {
  final String message;

  HideScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}
