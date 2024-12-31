import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dr_mohamed_salah_admin/core/data/local/cache_helper.dart';
import 'package:dr_mohamed_salah_admin/core/data/model/failure.dart';
import 'package:dr_mohamed_salah_admin/core/data/model/response_model.dart';
import 'package:dr_mohamed_salah_admin/core/data/remote/dio_helper.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/models/doctor_info_model.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/doctor_additions/service_model.dart';
import 'package:dr_mohamed_salah_admin/utils/api_utils/api_constant.dart';
import 'package:image_picker/image_picker.dart';

class MoreRepo {
  final Dio _dio = Dio();

  Future<List<DoctorInfoModel>> fetchDoctorInfo() async {
    try {
      final response = await _dio.get(
        '${ApiConstant.baseUrl}auth/get-doctor-info',
      );

      if (response.statusCode == 200) {
        final data = response.data['doctorInfo'] as List;
        return data.map((e) => DoctorInfoModel.fromJson(e)).toList();
      } else {
        throw Exception("Doctor data not found");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteCertificate(String doctorInfoId, String imagePath) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.delete(
        '${ApiConstant.baseUrl}${ApiConstant.deleteCertificate}$doctorInfoId',
        data: {"certificateLink": imagePath},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode != 200) {
        print('Failed to delete article: ${response.statusMessage}');
        throw Exception('Failed to delete article: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  Future<void> deleteArticle(String articleId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.delete(
        '${ApiConstant.baseUrl}${ApiConstant.deleteArticle}$articleId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode != 200) {
        print('Failed to delete article: ${response.statusMessage}');
        throw Exception('Failed to delete article: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  Future<Either<dynamic, Failure>> createArticle(
      XFile? articleImage, String? link, String content, String title) async {
    try {
      ResponseModel response = await DioHelper.post(
        isFormData: true,
        endPoint: ApiConstant.createArticle,
        data: {
          "image": await MultipartFile.fromFile(articleImage?.path ?? ""),
          "link": link,
          "content": content,
          "title": title,
        },
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> editArticle(String articleId, String? link,
      String? details, String? name, XFile? articleImage) async {
    try {
      final data = {
        "link": link,
        "content": details,
        "title": name,
        "image": await MultipartFile.fromFile(articleImage!.path)
      };

      ResponseModel response = await DioHelper.put(
        isFormData: true,
        endPoint: "${ApiConstant.editArticle}$articleId",
        data: data,
      );
      print("response.data: ${response.data}");
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  //////////////////////////////////////////////////////////////

  Future<void> editDoctorInfo({
    required String infoId,
    required String name,
    required String dateOfBirth,
    required String country,
    required String title,
    required String study,
    required String branches,
    String? facebookLink,
    String? instagramLink,
    String? youtubeLink,
    String? twitterLink,
    required List<File> images,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'dateOfBirth': dateOfBirth,
        'country': country,
        'title': title,
        'study': study,
        'branches': branches,
        'facebook': facebookLink ?? '',
        'instagram': instagramLink ?? '',
        'youtube': youtubeLink ?? '',
        'twitter': twitterLink ?? '',
        'images': await Future.wait(images.map((image) async {
          return await MultipartFile.fromFile(image.path);
        })),
      });

      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.put(
        '${ApiConstant.baseUrl}${ApiConstant.editDoctorInfo}$infoId',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        print("Failed to edit doctor info: ${response.statusMessage}");
        throw Exception(
            'Failed to edit doctor info: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to edit doctor info: $e');
    }
  }

  Future<void> addDoctorInfo({
    required String fullName,
    required String? birthDate,
    required String? country,
    required String? basicQualification,
    required String? graduateStudies,
    required String? branches,
    required List<File>? images,
    String? facebook,
    String? instagram,
    String? twitter,
    String? youtube,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "name": fullName,
        "dateOfBirth": birthDate,
        "country": country,
        "title": basicQualification,
        "study": graduateStudies,
        "branches": branches,
        "images": images
            ?.map((image) => MultipartFile.fromFileSync(image.path))
            .toList(),
        "facebook": facebook,
        "instagram": instagram,
        "twitter": twitter,
        "youtube": youtube,
      });

      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }

      Response response = await _dio.post(
        '${ApiConstant.baseUrl}admin/add-info',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 201) {
        if (response.data['message'] ==
            'Doctor information added successfully') {
          print('Success: Doctor information added');
          return;
        }
      } else {
        print('Failed: ${response.statusCode}, Response: ${response.data}');
        throw Exception('Failed to add doctor information: ${response.data}');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  ///////////////////////////////////////////////////////////

  Future<String?> uploadImage(File imageFile) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }

      final FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dio.put(
        '${ApiConstant.baseUrl}admin/upload-image',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data['image'] ?? 'Upload Successful';
      } else {
        throw Exception(
            'Failed to upload image: ${response.data['message'] ?? 'No message available'}');
      }
    } catch (e) {
      print('Error during image upload: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<String?> fetchImage() async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.get(
        '${ApiConstant.baseUrl}admin/get-image',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['image'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch image');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to fetch image: $e');
    }
  }

  ////////////////////////////////////////////////////////////////////////////

  Future<Either<dynamic, Failure>> getAllArticle() async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getAllArticle,
      );
      return Left(response.data);
    } on ResponseModel catch (responseModel) {
      return Left(responseModel);
    } on Failure catch (failure) {
      return Right(failure);
    }
  }

  Future<Either<dynamic, Failure>> getOneArticle(String id) async {
    try {
      ResponseModel response = await DioHelper.get(
        endPoint: ApiConstant.getOneArticle + id,
      );
      return Left(response.data);
    } on DioException catch (dioError) {
      return Right(Failure(dioError.message.toString()));
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }

///////////////////////////////////////////////////////////
// Doctor Addition Screen //
  Future<void> uploadAdsData(String? url, File? imageFile, int? period) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }

      if (imageFile == null || !imageFile.existsSync()) {
        throw Exception("Image file not found");
      }
      final formData = FormData.fromMap({
        'link': url ?? "",
        'image': await MultipartFile.fromFile(imageFile.path),
        'seconds': period ?? 5
      });

      final response = await _dio.post(
        '${ApiConstant.baseUrl}${ApiConstant.addAd}',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201 ||
          response.data['message'] == "Ad added successfully") {
        return response.data;
      } else {
        throw Exception(
            'Failed to upload data: ${response.data['message'] ?? 'No message'}');
      }
    } catch (e) {
      print('Error during data upload: $e');
      throw Exception('Failed to upload data: $e');
    }
  }

  Future<List<dynamic>> fetchAllAds() async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.get(
        '${ApiConstant.baseUrl}${ApiConstant.getAllAds}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> ads = response.data['ads'];
        return ads;
      } else {
        throw Exception("Ads data not found");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteAd(String adId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.delete(
        '${ApiConstant.baseUrl}${ApiConstant.deleteAd}$adId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        print('Failed to delete article: ${response.statusMessage}');
        throw Exception('Failed to delete article: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  ///////////////
  /// services functions
  Future<void> createService(String name, int price) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }

      final response = await _dio.post(
        "${ApiConstant.baseUrl}${ApiConstant.addService}",
        data: {
          'name': name,
          'price': price,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data['message'] == 'success') {
        print('Service created successfully');
      } else {
        throw Exception('Failed to create service');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> addHours(int hours) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }

      final response = await _dio.post(
        "${ApiConstant.baseUrl}${ApiConstant.addHours}",
        data: {
          'number': hours,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Number Added Successfully');
      } else {
        throw Exception('Unexpected error occurred');
      }
    } on DioError catch (dioError) {
      if (dioError.response?.statusCode == 400) {
        final responseData = dioError.response?.data;
        final serverMessage = responseData['message'] ??
            (responseData['data']['errors']?.isNotEmpty ?? false
                ? responseData['data']['errors'][0]
                : 'Invalid request');
        throw Exception(serverMessage);
      } else {
        throw Exception('Failed to upload number: ${dioError.message}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<Service>> getAllServices() async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }

      final response = await _dio.get(
        '${ApiConstant.baseUrl}${ApiConstant.getAllService}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> serviceList = response.data['services'];
        final List<Service> services = serviceList
            .map((serviceData) => Service.fromJson(serviceData))
            .toList();
        return services;
      } else {
        throw Exception("Services data not found");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }
      final response = await _dio.delete(
        '${ApiConstant.baseUrl}${ApiConstant.deleteService}$serviceId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        print('Failed to delete article: ${response.statusMessage}');
        throw Exception('Failed to delete article: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  Future<void> editService(String? name, int? price, String serviceId) async {
    try {
      final String? token = await CacheHelper.getToken();
      if (token == null) {
        throw const Failure('Admin token not found');
      }

      final formData = FormData.fromMap({
        'name': name ?? "",
        'price': price ?? 0,
      });

      final response = await _dio.patch(
        '${ApiConstant.baseUrl}${ApiConstant.updateService}$serviceId',
        data: {
          'name': name ?? "",
          'price': price ?? 0,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Service updated successfully.');
      } else {
        print('Failed to update article: ${response.statusMessage}');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to edit article: $e');
    }
  }
}
