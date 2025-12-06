import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for email/password sign-in
class SignInWithEmail {
  final AuthRepository _repository;

  SignInWithEmail(this._repository);

  /// Execute the use case
  Future<Either<Failure, User>> call(SignInWithEmailParams params) {
    return _repository.signInWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for email sign-in
class SignInWithEmailParams extends Equatable {
  final String email;
  final String password;

  const SignInWithEmailParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
