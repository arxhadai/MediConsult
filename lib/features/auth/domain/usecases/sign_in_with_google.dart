import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../enums/user_role.dart';
import '../repositories/auth_repository.dart';

/// Use case for Google sign-in
@Injectable()
class SignInWithGoogle {
  final AuthRepository _repository;

  SignInWithGoogle(this._repository);

  /// Execute the use case
  Future<Either<Failure, User>> call(SignInWithGoogleParams params) {
    return _repository.signInWithGoogle(role: params.role);
  }
}

/// Parameters for Google sign-in
class SignInWithGoogleParams extends Equatable {
  final UserRole role;

  const SignInWithGoogleParams({required this.role});

  @override
  List<Object?> get props => [role];
}
