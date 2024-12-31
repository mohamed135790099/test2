import 'package:dio/dio.dart';
import 'package:dr_mohamed_salah_admin/core/data/model/response_model.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';

class AppException implements Exception {
  final String? _message;

  AppException([this._message]) {
    print(_message);
  }

  @override
  String toString() {
    return "$_message";
  }
}

handleDioExceptions(DioException error, bool showErrorMessage) {
  print("Error IS : $error");
  print("type IS : ${error.type}");
  print("response IS : ${error.response}");
  if (error.response != null) {
    final data = error.response?.data;
    if (data != null && data.toString().isNotEmpty) {
      final responseModel = ResponseModel.fromJson(data);
      if (responseModel.message != null) {
        if (showErrorMessage) {
          AppToaster.show(responseModel.message ?? "");
        }
      }
    }

    throw AppException(error.response?.statusMessage ?? "");
  } else {
    throw AppException(error.toString());
  }
}
