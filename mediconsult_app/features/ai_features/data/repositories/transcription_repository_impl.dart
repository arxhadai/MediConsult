import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transcription_segment.dart';
import '../../domain/repositories/transcription_repository.dart';
import '../datasources/speech_recognition_service.dart';
import '../models/transcription_segment_model.dart';

/// Implementation of transcription repository
class TranscriptionRepositoryImpl implements TranscriptionRepository {
  final SpeechRecognitionService _speechRecognitionService;
  late final StreamController<TranscriptionSegment> _transcriptionController;

  TranscriptionRepositoryImpl(this._speechRecognitionService) {
    _transcriptionController = StreamController<TranscriptionSegment>.broadcast();
    _initializeStream();
  }

  void _initializeStream() {
    _speechRecognitionService.speechStream.listen(
      (TranscriptionSegmentModel model) {
        _transcriptionController.add(model.toEntity());
      },
      onError: (error) {
        _transcriptionController.addError(error);
      },
    );
  }

  @override
  Future<Either<Failure, void>> startTranscription() async {
    return await _speechRecognitionService.startListening();
  }

  @override
  Future<Either<Failure, void>> stopTranscription() async {
    return await _speechRecognitionService.stopListening();
  }

  @override
  Stream<TranscriptionSegment> get transcriptionStream => _transcriptionController.stream;

  void dispose() {
    _transcriptionController.close();
  }
}