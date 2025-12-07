import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../models/transcription_segment_model.dart';
import 'speech_recognition_service.dart';

/// Implementation of speech recognition service
@LazySingleton(as: SpeechRecognitionService)
class SpeechRecognitionServiceImpl implements SpeechRecognitionService {
  static const logger = AppLogger;
  final SpeechToText _speechToText = SpeechToText();
  final StreamController<TranscriptionSegmentModel> _speechController =
      StreamController<TranscriptionSegmentModel>.broadcast();
  final Uuid _uuid = const Uuid();

  bool _isListening = false;
  DateTime? _segmentStartTime;

  @override
  Stream<TranscriptionSegmentModel> get speechStream =>
      _speechController.stream;

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      final isAvailable = await _speechToText.initialize(
        onError: _onSpeechError,
        onStatus: _onSpeechStatus,
      );

      if (!isAvailable) {
        return Left(ServerFailure('Speech recognition not available'));
      }

      return const Right(null);
    } catch (e) {
      AppLogger.error('Error initializing speech recognition: $e');
      return Left(ServerFailure('Failed to initialize speech recognition'));
    }
  }

  @override
  Future<Either<Failure, void>> startListening() async {
    try {
      if (!_speechToText.isAvailable) {
        return Left(ServerFailure('Speech recognition not available'));
      }

      if (_isListening) {
        return const Right(null);
      }

      _segmentStartTime = DateTime.now();
      _isListening = true;

      _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: 'en_US',
        listenFor: const Duration(minutes: 5),
      );

      return const Right(null);
    } catch (e) {
      AppLogger.error('Error starting speech recognition: $e');
      return Left(ServerFailure('Failed to start speech recognition'));
    }
  }

  @override
  Future<Either<Failure, void>> stopListening() async {
    try {
      if (!_isListening) {
        return const Right(null);
      }

      _speechToText.stop();
      _isListening = false;
      _segmentStartTime = null;

      return const Right(null);
    } catch (e) {
      AppLogger.error('Error stopping speech recognition: $e');
      return Left(ServerFailure('Failed to stop speech recognition'));
    }
  }

  @override
  Future<bool> isAvailable() async {
    return _speechToText.isAvailable;
  }

  void _onSpeechResult(dynamic result) {
    if (_segmentStartTime == null) return;

    final segment = TranscriptionSegmentModel(
      id: _uuid.v4(),
      speakerId: 1, // Default speaker ID for patient
      speakerName: 'Patient',
      text: result.recognizedWords,
      startTime: _segmentStartTime!,
      endTime: DateTime.now(),
      confidence: result.confidence,
    );

    _speechController.add(segment);

    // Update start time for next segment if this is a final result
    if (result.finalResult) {
      _segmentStartTime = DateTime.now();
    }
  }

  void _onSpeechStatus(String status) {
    AppLogger.info('Speech recognition status: $status');
  }

  void _onSpeechError(dynamic error) {
    AppLogger.error('Speech recognition error: ${error.errorMsg}');
    _speechController.addError(ServerFailure(error.errorMsg));
  }

  void dispose() {
    _speechController.close();
  }
}
