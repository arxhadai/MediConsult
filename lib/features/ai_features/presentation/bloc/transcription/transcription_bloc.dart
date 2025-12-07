import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/utils/logger.dart';
import '../../../domain/entities/transcription_segment.dart';
import '../../../domain/usecases/start_transcription.dart';
import '../../../domain/usecases/stop_transcription.dart';

part 'transcription_event.dart';
part 'transcription_state.dart';

/// BLoC for transcription feature
@injectable
class TranscriptionBloc extends Bloc<TranscriptionEvent, TranscriptionState> {
  static const logger = AppLogger;
  final StartTranscription _startTranscription;
  final StopTranscription _stopTranscription;
  StreamSubscription<TranscriptionSegment>? _transcriptionSubscription;

  TranscriptionBloc(
    this._startTranscription,
    this._stopTranscription,
  ) : super(TranscriptionInitial()) {
    on<TranscriptionStarted>(_onTranscriptionStarted);
    on<TranscriptionStopped>(_onTranscriptionStopped);
    on<TranscriptionSegmentReceived>(_onTranscriptionSegmentReceived);
  }

  Future<void> _onTranscriptionStarted(
    TranscriptionStarted event,
    Emitter<TranscriptionState> emit,
  ) async {
    emit(TranscriptionActive());
    
    try {
      final result = await _startTranscription();
      
      result.fold(
        (failure) {
          emit(TranscriptionError(
            message: failure.toString(),
          ));
        },
        (_) {
          // Transcription started successfully
        },
      );
    } catch (e) {
      AppLogger.error('Error starting transcription: $e');
      emit(TranscriptionError(message: 'Failed to start transcription'));
    }
  }

  Future<void> _onTranscriptionStopped(
    TranscriptionStopped event,
    Emitter<TranscriptionState> emit,
  ) async {
    try {
      final result = await _stopTranscription();
      
      result.fold(
        (failure) {
          emit(TranscriptionError(
            message: failure.toString(),
          ));
        },
        (_) {
          emit(TranscriptionInactive());
        },
      );
    } catch (e) {
      AppLogger.error('Error stopping transcription: $e');
      emit(TranscriptionError(message: 'Failed to stop transcription'));
    }
  }

  Future<void> _onTranscriptionSegmentReceived(
    TranscriptionSegmentReceived event,
    Emitter<TranscriptionState> emit,
  ) async {
    emit(TranscriptionSegmentAvailable(segment: event.segment));
  }

  @override
  Future<void> close() {
    _transcriptionSubscription?.cancel();
    return super.close();
  }
}