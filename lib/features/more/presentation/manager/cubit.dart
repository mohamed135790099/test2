import 'dart:io';

import 'package:dr_mohamed_salah_admin/features/more/data/models/article_details_model.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/models/article_model.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/repositories/more_repo.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class MoreCubit extends Cubit<MoreState> {
  final MoreRepo _moreRepo;

  MoreCubit(this._moreRepo) : super(InitState());

  static MoreCubit get(context) => BlocProvider.of(context);

  Future<void> deleteCertificate(String certificateId, String imagePath) async {
    emit(DeleteCertificateLoading());
    try {
      await _moreRepo.deleteCertificate(certificateId, imagePath);
      emit(DeleteCertificateSuccess());
    } catch (e) {
      emit(DeleteCertificateError(e.toString()));
    }
  }

  Future<void> deleteArticle(String articleId) async {
    emit(DeleteArticleLoading());
    try {
      await _moreRepo.deleteArticle(articleId);
      await _moreRepo.getAllArticle();
      emit(DeleteArticleSuccess());
    } catch (e) {
      emit(DeleteArticleError(e.toString()));
    }
  }

  XFile? _articleImage;

  XFile? get articleImage => _articleImage;

  void removeArticleImage() {
    _articleImage = null;
    emit(GetArticleImageSuccess());
  }

  Future<void> getArticleImage(BuildContext context) async {
    emit(GetArticleImageLoading());

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _articleImage = XFile(pickedFile.path);
      emit(GetArticleImageSuccess());
    } else {
      emit(GetArticleImageError());
    }
  }

  Future<void> editArticle(
      String articleId, String? link, String? details, String? name) async {
    emit(EditArticleLoading());

    if (articleImage == null) {
      emit(EditArticleError('Article image cannot be null'));
      return;
    }

    final result = await _moreRepo.editArticle(
        articleId, link, details, name, articleImage!);
    result.fold((l) async {
      getAllArticle();
      emit(EditArticleSuccess());
    }, (r) {
      print(r.message);
      emit(EditArticleError(r.message));
    });
  }

  Future<void> createArticle(String? link, String content, String title) async {
    emit(CreateArticlesLoading());
    final result =
        await _moreRepo.createArticle(articleImage, link, content, title);
    result.fold((l) async {
      getAllArticle();
      emit(CreateArticlesSuccess());
    }, (r) => emit(CreateArticlesError()));
  }

  //////////////////////////////////////////////////////////

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
    emit(DoctorInfoLoading());
    try {
      await _moreRepo.editDoctorInfo(
        infoId: infoId,
        name: name,
        dateOfBirth: dateOfBirth,
        country: country,
        title: title,
        study: study,
        branches: branches,
        facebookLink: facebookLink,
        instagramLink: instagramLink,
        youtubeLink: youtubeLink,
        twitterLink: twitterLink,
        images: images,
      );
      emit(DoctorInfoSuccess());
    } catch (e) {
      print(e.toString());
      emit(DoctorInfoError(e.toString()));
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
    String? facebookLink,
    String? instagramLink,
    String? twitterLink,
    String? youtubeLink,
  }) async {
    emit(AddDoctorInfoLoading());
    try {
      await _moreRepo.addDoctorInfo(
          fullName: fullName,
          birthDate: birthDate,
          country: country,
          basicQualification: basicQualification,
          graduateStudies: graduateStudies,
          branches: branches,
          images: images,
          facebook: facebookLink,
          instagram: instagramLink,
          youtube: youtubeLink,
          twitter: twitterLink);
      emit(AddDoctorInfoSuccess());
    } catch (e) {
      emit(AddDoctorInfoFailure(e.toString()));
    }
  }

  Future<void> uploadImage(File image) async {
    emit(MoreImageUploadLoading());
    try {
      final String? imageUrl = await _moreRepo.uploadImage(image);
      if (imageUrl != null) {
        await fetchImage();
      } else {
        emit(MoreImageUploadError('Image upload failed'));
      }
    } catch (e) {
      emit(MoreImageUploadError(e.toString()));
    }
  }

  Future<void> fetchImage() async {
    emit(MoreImageFetchLoading());
    try {
      final String? imageUrl = await _moreRepo.fetchImage();
      emit(MoreImageFetchSuccess(imageUrl));
    } catch (e) {
      emit(MoreImageFetchError(e.toString()));
    }
  }

  ArticleDetailsModel? articleDetailsModel;

  Future<void> getOneArticle(String id) async {
    emit(GetOneArticleLoading());
    final result = await _moreRepo.getOneArticle(id);
    result.fold(
      (l) {
        final article = ArticleDetailsModel.fromJson(l["Article"]);
        articleDetailsModel = article;
        emit(GetOneArticleSuccess(articleDetailsModel: article));
      },
      (r) {
        emit(GetOneArticleError(r.message));
      },
    );
  }

  List<ArticleModel> allArticles = [];

  Future<void> getAllArticle() async {
    emit(GetAllArticlesLoading());
    final result = await _moreRepo.getAllArticle();
    result.fold(
      (l) async {
        final allArticle = l["Articles"];
        if (allArticle != null) {
          allArticles = allArticle
              .map<ArticleModel>((e) => ArticleModel.fromJson(e))
              .toList();
        }

        emit(GetAllArticlesSuccess());
      },
      (r) => emit(GetAllArticlesError()),
    );
  }

  //////////////////////////////////////////////////////////////

  Future<void> fetchDoctorInfo() async {
    emit(FetchDoctorInfoLoading());
    try {
      final doctorInfo = await _moreRepo.fetchDoctorInfo();
      emit(FetchDoctorInfoLoaded(doctorInfo));
    } catch (e) {
      emit(FetchDoctorInfoFailure(e.toString()));
    }
  }
}
