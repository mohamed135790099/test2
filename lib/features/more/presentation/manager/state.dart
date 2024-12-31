import 'package:dr_mohamed_salah_admin/features/more/data/models/article_details_model.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/models/doctor_info_model.dart';

abstract class MoreState {}

class InitState extends MoreState {}

class EditArticleLoading extends MoreState {}

class EditArticleSuccess extends MoreState {}

class EditArticleError extends MoreState {
  final String error;

  EditArticleError(this.error);
}

class DeleteArticleLoading extends MoreState {}

class DeleteArticleSuccess extends MoreState {}

class DeleteArticleError extends MoreState {
  final String error;

  DeleteArticleError(this.error);
}

class DeleteCertificateLoading extends MoreState {}

class DeleteCertificateSuccess extends MoreState {}

class DeleteCertificateError extends MoreState {
  final String error;

  DeleteCertificateError(this.error);
}

class DoctorInfoError extends MoreState {
  final String error;

  DoctorInfoError(this.error);
}

class DoctorInfoLoading extends MoreState {}

class DoctorInfoSuccess extends MoreState {}

///////////////////////////////////////////////////////
class AddDoctorInfoLoading extends MoreState {}

class AddDoctorInfoSuccess extends MoreState {}

class AddDoctorInfoFailure extends MoreState {
  final String error;

  AddDoctorInfoFailure(this.error);

  @override
  List<Object> get props => [error];
}
//////////////////////////////////////////////////////

class MoreImageUploadLoading extends MoreState {}

class MoreImageUploadSuccess extends MoreState {
  final String imageUrl;

  MoreImageUploadSuccess(this.imageUrl);
}

class MoreImageUploadError extends MoreState {
  final String message;

  MoreImageUploadError(this.message);
}

class MoreImageFetchLoading extends MoreState {}

class MoreImageFetchSuccess extends MoreState {
  final String? imageUrl;

  MoreImageFetchSuccess(this.imageUrl);
}

class MoreImageFetchError extends MoreState {
  final String message;

  MoreImageFetchError(this.message);
}

class GetArticleImageLoading extends MoreState {}

class GetArticleImageSuccess extends MoreState {}

class GetArticleImageError extends MoreState {}

class GetOneArticleLoading extends MoreState {}

class GetOneArticleSuccess extends MoreState {
  final ArticleDetailsModel articleDetailsModel;

  GetOneArticleSuccess({required this.articleDetailsModel});
}

class GetOneArticleError extends MoreState {
  String error;

  GetOneArticleError(this.error);
}

class GetAllArticlesLoading extends MoreState {}

class GetAllArticlesSuccess extends MoreState {}

class GetAllArticlesError extends MoreState {}

class CreateArticlesLoading extends MoreState {}

class CreateArticlesSuccess extends MoreState {}

class CreateArticlesError extends MoreState {}

///////////////////////////////////////////////////////

class FetchDoctorInfoLoading extends MoreState {}

class FetchDoctorInfoLoaded extends MoreState {
  final List<DoctorInfoModel> doctorInfo;

  FetchDoctorInfoLoaded(this.doctorInfo);

  @override
  List<Object> get props => [doctorInfo];
}

class FetchDoctorInfoFailure extends MoreState {
  final String error;

  FetchDoctorInfoFailure(this.error);

  @override
  List<Object> get props => [error];
}
