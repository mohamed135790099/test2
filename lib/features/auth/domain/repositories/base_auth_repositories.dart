import 'package:dartz/dartz.dart';
import 'package:dr_mohamed_salah_admin/core/data/exceptions/exceptions.dart';
import 'package:dr_mohamed_salah_admin/features/auth/domain/use_cases/sign_in_usecase.dart';

abstract class BaseAuthRepositories {
  Future<Either<AppException, void>> signIn(SignInParameters signInParameters);
}
