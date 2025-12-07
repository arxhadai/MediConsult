import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/transcription_segment_model.dart';

/// Abstract class for speech recognition service
abstract class SpeechRecognitionService {
  /// Initialize speech recognition
  Future<Either<Failure, void>> initialize();

  /// Start listening for speech
  Future<Either<Failure, void>> startListening();

  /// Stop listening for speech
  Future<Either<Failure, void>> stopListening();

  /// Get stream of speech recognition results
  Stream<TranscriptionSegmentModel> get speechStream;

  /// Check if speech recognition is available
  Future<bool> isAvailable();
}