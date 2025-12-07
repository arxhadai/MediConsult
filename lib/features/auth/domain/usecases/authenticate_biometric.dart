import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for authenticating with biometrics
@Injectable()
class AuthenticateBiometric {
  final AuthRepository _repository;

  AuthenticateBiometric(this._repository);

  /// Execute the use case
  Future<Either<Failure, User>> call() {
    return _repository.authenticateWithBiometric();
  }

  /// Check if biometrics is available on device
  Future<bool> isAvailable() {
    return _repository.isBiometricAvailable();
  }

  /// Check if biometrics is enabled for current user
  Future<bool> isEnabled() {
    return _repository.isBiometricEnabled();
  }
}
