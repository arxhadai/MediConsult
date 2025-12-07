import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for resetting password
@Injectable()
class ResetPassword {
  final AuthRepository _repository;

  ResetPassword(this._repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return _repository.sendPasswordResetEmail(email: params.email);
  }
}

/// Parameters for password reset
class ResetPasswordParams extends Equatable {
  final String email;

  const ResetPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}
