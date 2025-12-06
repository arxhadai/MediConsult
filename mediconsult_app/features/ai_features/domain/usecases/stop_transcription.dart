import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transcription_repository.dart';

/// Use case for stopping transcription
class StopTranscription {
  final TranscriptionRepository repository;

  StopTranscription(this.repository);

  /// Execute the use case to stop transcription
  Future<Either<Failure, void>> call() {
    return repository.stopTranscription();
  }
}