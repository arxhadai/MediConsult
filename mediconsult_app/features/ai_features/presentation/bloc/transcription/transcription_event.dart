part of 'transcription_bloc.dart';

/// Base event class for transcription
abstract class TranscriptionEvent {}

/// Event triggered when transcription is started
class TranscriptionStarted extends TranscriptionEvent {}

/// Event triggered when transcription is stopped
class TranscriptionStopped extends TranscriptionEvent {}

/// Event triggered when a new transcription segment is received
class TranscriptionSegmentReceived extends TranscriptionEvent {
  final TranscriptionSegment segment;

  TranscriptionSegmentReceived({required this.segment});
}