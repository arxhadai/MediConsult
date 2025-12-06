import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing out
class SignOut {
  final AuthRepository _repository;

  SignOut(this._repository);

  /// Execute the use case
  Future<Either<Failure, void>> call() {
    return _repository.signOut();
  }
}
