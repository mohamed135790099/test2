import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dr_mohamed_salah_admin/core/data/model/failure.dart';
import 'package:dr_mohamed_salah_admin/core/data/model/response_model.dart';
import 'package:dr_mohamed_salah_admin/core/data/remote/dio_helper.dart';
import 'package:dr_mohamed_salah_admin/utils/api_utils/api_constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SignInRepo {
  Future<Either<Map<String, dynamic>, Failure>> signInAdmin(
      String userName, String password) async {
    try {
      final String subscriptionId =
          OneSignal.User.pushSubscription.id.toString();
      print(subscriptionId);
      final response = await DioHelper.post(
          endPoint: ApiConstant.signInAdmin,
          data: {
            "userName": userName,
            "password": password,
            "subscriptionId": subscriptionId
          });

      if (response.statusCode == 200 && response.data['token'] != null) {
        return Left(response.data);
      } else {
        return Right(Failure(response.data['message'] ?? "An error occurred"));
      }
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }

  Future<Either<dynamic, Failure>> createAdmin(
      String userName, String password) async {
    try {
      ResponseModel response = await DioHelper.post(
          endPoint: ApiConstant.createAdmin,
          data: {"userName": userName, "password": password});
      print(response.data.toString());
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> createUserByAdmin(
      String fullName, String password) async {
    try {
      ResponseModel response = await DioHelper.post(
          endPoint: ApiConstant.createUserByAdmin,
          data: {"fullName": fullName, "password": password});
      print(response.data.toString());
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getAdminProfilePic() async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getAdminProfilePic,
      );
      print(response.data.toString());
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> uploadAdminProfilePic(XFile? image) async {
    try {
      ResponseModel response = await DioHelper.put(
          endPoint: ApiConstant.uploadAdminProfilePic,
          data: {
            "image": await MultipartFile.fromFile(image?.path ?? ""),
          });
      print(response.data.toString());
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getAllUsers() async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getAdminAllUsers,
      );
      print(response.data.toString());
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }
}
