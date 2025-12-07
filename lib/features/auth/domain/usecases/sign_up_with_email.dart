import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../enums/user_role.dart';
import '../repositories/auth_repository.dart';

/// Use case for registering new user with email
@Injectable()
class SignUpWithEmail {
  final AuthRepository _repository;

  SignUpWithEmail(this._repository);

  /// Execute the use case
  Future<Either<Failure, User>> call(SignUpWithEmailParams params) {
    return _repository.signUpWithEmail(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
      role: params.role,
    );
  }
}

/// Parameters for email registration
class SignUpWithEmailParams extends Equatable {
  final String email;
  final String password;
  final String displayName;
  final UserRole role;

  const SignUpWithEmailParams({
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password, displayName, role];
}
