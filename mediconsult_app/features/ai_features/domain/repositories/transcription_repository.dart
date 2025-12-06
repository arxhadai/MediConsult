import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transcription_segment.dart';

/// Repository interface for transcription features
abstract class TranscriptionRepository {
  /// Start speech recognition
  Future<Either<Failure, void>> startTranscription();

  /// Stop speech recognition
  Future<Either<Failure, void>> stopTranscription();

  /// Get stream of transcription segments
  Stream<TranscriptionSegment> get transcriptionStream;
}