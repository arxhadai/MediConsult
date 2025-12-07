import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

/// Use case for checking authentication status
@Injectable()
class CheckAuthStatus {
  final AuthRepository _repository;

  CheckAuthStatus(this._repository);

  /// Execute the use case
  Future<bool> call() {
    return _repository.isAuthenticated();
  }

  /// Check if biometric is available
  Future<bool> isBiometricAvailable() {
    return _repository.isBiometricAvailable();
  }

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() {
    return _repository.isBiometricEnabled();
  }
}
