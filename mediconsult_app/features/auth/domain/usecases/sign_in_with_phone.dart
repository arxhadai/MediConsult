import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for initiating phone sign-in (sends OTP)
class SignInWithPhone {
  final AuthRepository _repository;

  SignInWithPhone(this._repository);

  /// Execute the use case
  /// Returns verification ID needed for OTP verification
  Future<Either<Failure, String>> call(SignInWithPhoneParams params) {
    return _repository.signInWithPhone(phoneNumber: params.phoneNumber);
  }
}

/// Parameters for phone sign-in
class SignInWithPhoneParams extends Equatable {
  final String phoneNumber;

  const SignInWithPhoneParams({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}
