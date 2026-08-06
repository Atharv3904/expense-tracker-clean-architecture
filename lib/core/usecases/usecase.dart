// ignore_for_file: avoid_types_as_parameter_names

import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<AppFailure, Type>> call(Params params);
}
