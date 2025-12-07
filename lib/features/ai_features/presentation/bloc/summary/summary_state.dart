part of 'summary_bloc.dart';

/// Base state class for summary
abstract class SummaryState {}

/// Initial state
class SummaryInitial extends SummaryState {}

/// Loading state
class SummaryLoading extends SummaryState {}

/// Success state with generated summary
class SummarySuccess extends SummaryState {
  final ConsultationSummary summary;

  SummarySuccess({required this.summary});
}

/// Error state
class SummaryError extends SummaryState {
  final String message;

  SummaryError({required this.message});
}