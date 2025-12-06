part of 'symptom_checker_bloc.dart';

/// Base state class for symptom checker
abstract class SymptomCheckerState {}

/// Initial state
class SymptomCheckerInitial extends SymptomCheckerState {}

/// Loading state
class SymptomCheckerLoading extends SymptomCheckerState {}

/// Success state with symptom analysis result
class SymptomCheckerSuccess extends SymptomCheckerState {
  final SymptomAnalysis analysis;

  SymptomCheckerSuccess({required this.analysis});
}

/// Chat message state
class ChatMessageReceived extends SymptomCheckerState {
  final ChatMessage message;
  final List<ChatMessage> chatHistory;

  ChatMessageReceived({
    required this.message,
    required this.chatHistory,
  });
}

/// Error state
class SymptomCheckerError extends SymptomCheckerState {
  final String message;

  SymptomCheckerError({required this.message});
}