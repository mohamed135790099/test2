import 'package:dio/dio.dart';
import 'package:dr_mohamed_salah_admin/core/data/local/cache_helper.dart';
import 'package:dr_mohamed_salah_admin/core/data/model/response_model.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/book_times_state.dart';
import 'package:dr_mohamed_salah_admin/utils/api_utils/api_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingTimesCubit extends Cubit<BookingTimesState> {
  final Dio _dio = Dio();

  BookingTimesCubit() : super(BookingTimesInitial());

  static BookingTimesCubit get(context) => BlocProvider.of(context);

  Future<String?> _getAuthToken() async {
    return CacheHelper.getToken();
  }

  Future<void> fetchBookingDays() async {
    emit(BookingTimesLoading());
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        emit(BookingTimesError("Authentication token is missing"));
        return;
      }

      final response = await _dio.get(
        '${ApiConstant.baseUrl}schedule/get-all-schedule',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['schedules'] ?? [];
        emit(BookingTimesLoaded(data));
      } else {
        emit(BookingTimesError(
            'Failed to fetch booking days. Status code: ${response.statusCode},'
            ' Response: ${response.data}'));
      }
    } catch (e) {
      emit(BookingTimesError('Failed to fetch booking days. Error: $e'));
    }
  }

  Future<void> submitSchedule(Map<String, dynamic> bookingData) async {
    if (bookingData.isEmpty) {
      emit(BookingTimesError("No days selected"));
      return;
    }
    try {
      emit(BookingTimesLoading());

      final authToken = await _getAuthToken();
      if (authToken == null) {
        emit(BookingTimesError("Authentication token is missing"));
        return;
      }

      final response = await _dio.post(
        '${ApiConstant.baseUrl}schedule/create-schedule',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken',
          },
        ),
        data: bookingData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(BookingTimesSuccess());
      } else {
        final responseData = ResponseModel.fromJson(response.data);
        final errorMessage = responseData.messageAr ??
            responseData.message ??
            "Failed to submit data.";
        emit(BookingTimesError(errorMessage));
      }
    } catch (e) {
      if (e is DioException && e.response != null && e.response!.data != null) {
        final errorData = ResponseModel.fromJson(e.response!.data);
        final errorMessage = errorData.messageAr ??
            errorData.message ??
            "Failed to submit data.";
        emit(BookingTimesError(errorMessage));
      } else {
        emit(BookingTimesError("Failed to submit data. Error: $e"));
      }
    }
  }

  Future<void> updateBooking(
      String id, Map<String, dynamic> bookingData) async {
    if (bookingData.isEmpty) {
      emit(BookingTimesError("No booking data provided"));
      return;
    }

    try {
      emit(BookingTimesLoading());

      final authToken = await _getAuthToken();
      if (authToken == null) {
        emit(BookingTimesError("Authentication token is missing"));
        return;
      }

      final response = await _dio.patch(
        '${ApiConstant.baseUrl}schedule/edit-schedule/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken',
          },
        ),
        data: bookingData,
      );

      if (response.statusCode == 200) {
        emit(BookingTimesSuccess());
      } else {
        emit(BookingTimesError(
            'Failed to update booking. Status code: ${response.statusCode}, Response: ${response.data}'));
      }
    } catch (e) {
      emit(BookingTimesError('Failed to update booking. Error: $e'));
    }
  }

  Future<void> hideSchedule(String scheduleId) async {
    emit(HideScheduleLoading());
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        emit(HideScheduleError("Authentication token is missing"));
        return;
      }

      final response = await _dio.patch(
        '${ApiConstant.baseUrl}${ApiConstant.hideSchedule}$scheduleId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        emit(HideScheduleSuccess());
        await fetchBookingDays();
      } else {
        emit(HideScheduleError(response.data));
      }
    } catch (e) {
      emit(HideScheduleError('Error: $e'));
    }
  }
}
