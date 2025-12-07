import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

/// Base class for all prescription use cases
abstract class PrescriptionUseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}