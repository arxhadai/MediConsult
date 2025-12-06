part of 'summary_bloc.dart';

/// Base event class for summary
abstract class SummaryEvent {}

/// Event triggered when summary generation is requested
class SummaryGenerationRequested extends SummaryEvent {
  final String consultationTranscript;

  SummaryGenerationRequested({required this.consultationTranscript});
}