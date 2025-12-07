import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for enabling biometric authentication
@Injectable()
class EnableBiometric {
  final AuthRepository _repository;

  EnableBiometric(this._repository);

  /// Execute the use case
  Future<Either<Failure, void>> call() {
    return _repository.enableBiometric();
  }
}
