import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for updating user profile
class UpdateProfile {
  final AuthRepository _repository;

  UpdateProfile(this._repository);

  /// Execute the use case
  Future<Either<Failure, User>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      displayName: params.displayName,
      photoUrl: params.photoUrl,
      additionalData: params.additionalData,
    );
  }
}

/// Parameters for profile update
class UpdateProfileParams extends Equatable {
  final String? displayName;
  final String? photoUrl;
  final Map<String, dynamic>? additionalData;

  const UpdateProfileParams({
    this.displayName,
    this.photoUrl,
    this.additionalData,
  });

  @override
  List<Object?> get props => [displayName, photoUrl, additionalData];
}
