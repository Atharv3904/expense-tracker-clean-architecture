import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';

typedef AppResult<T> = Future<Either<AppFailure, T>>;
