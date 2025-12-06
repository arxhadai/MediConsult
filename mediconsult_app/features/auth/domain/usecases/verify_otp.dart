import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../enums/user_role.dart';
import '../repositories/auth_repository.dart';

/// Use case for verifying OTP code
class VerifyOtp {
  final AuthRepository _repository;

  VerifyOtp(this._repository);

  /// Execute the use case
  Future<Either<Failure, User>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(
      verificationId: params.verificationId,
      otp: params.otp,
      role: params.role,
    );
  }
}

/// Parameters for OTP verification
class VerifyOtpParams extends Equatable {
  final String verificationId;
  final String otp;
  final UserRole role;

  const VerifyOtpParams({
    required this.verificationId,
    required this.otp,
    required this.role,
  });

  @override
  List<Object?> get props => [verificationId, otp, role];
}
