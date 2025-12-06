import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_call_repository.dart';

/// Parameters for toggling video
class ToggleVideoParams extends Equatable {
  final bool enabled;

  const ToggleVideoParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Use case for toggling video on/off
class ToggleVideo {
  final VideoCallRepository repository;

  ToggleVideo(this.repository);

  Future<Either<Failure, void>> call(ToggleVideoParams params) async {
    return await repository.toggleVideo(params.enabled);
  }
}