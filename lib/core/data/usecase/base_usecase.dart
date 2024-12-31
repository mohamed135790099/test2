import 'package:dartz/dartz.dart';
import 'package:dr_mohamed_salah_admin/core/data/exceptions/exceptions.dart';
import 'package:equatable/equatable.dart';

abstract class BaseUseCase<T, Parameters> {
  Future<Either<AppException, T>> call(Parameters parameters);
}

class NoParameters extends Equatable {
  const NoParameters();

  @override
  List<Object> get props => [];
}
