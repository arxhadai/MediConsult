import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_call_repository.dart';

/// Parameters for toggling audio
class ToggleAudioParams extends Equatable {
  final bool enabled;

  const ToggleAudioParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Use case for toggling audio on/off
class ToggleAudio {
  final VideoCallRepository repository;

  ToggleAudio(this.repository);

  Future<Either<Failure, void>> call(ToggleAudioParams params) async {
    return await repository.toggleAudio(params.enabled);
  }
}