part of 'transcription_bloc.dart';

/// Base state class for transcription
abstract class TranscriptionState {}

/// Initial state
class TranscriptionInitial extends TranscriptionState {}

/// Transcription is active
class TranscriptionActive extends TranscriptionState {}

/// Transcription is inactive
class TranscriptionInactive extends TranscriptionState {}

/// New transcription segment available
class TranscriptionSegmentAvailable extends TranscriptionState {
  final TranscriptionSegment segment;

  TranscriptionSegmentAvailable({required this.segment});
}

/// Error state
class TranscriptionError extends TranscriptionState {
  final String message;

  TranscriptionError({required this.message});
}