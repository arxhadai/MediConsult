import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting the current user
class GetCurrentUser {
  final AuthRepository _repository;

  GetCurrentUser(this._repository);

  /// Execute the use case
  Future<Either<Failure, User?>> call() {
    return _repository.getCurrentUser();
  }

  /// Get auth state changes stream
  Stream<User?> get authStateChanges => _repository.authStateChanges;
}
