import 'package:dartz/dartz.dart';
import 'package:dr_mohamed_salah_admin/core/data/exceptions/exceptions.dart';
import 'package:dr_mohamed_salah_admin/core/data/usecase/base_usecase.dart';
import 'package:dr_mohamed_salah_admin/features/auth/domain/repositories/base_auth_repositories.dart';
import 'package:equatable/equatable.dart';

class SignInUseCase extends BaseUseCase<void, SignInParameters> {
  BaseAuthRepositories baseAuthRepositories;

  SignInUseCase({
    required this.baseAuthRepositories,
  });

  @override
  Future<Either<AppException, void>> call(SignInParameters parameters) async {
    return await baseAuthRepositories.signIn(parameters);
  }
}

class SignInParameters extends Equatable {
  final String phone;

  const SignInParameters({required this.phone});

  @override
  List<Object> get props => [phone];
}
