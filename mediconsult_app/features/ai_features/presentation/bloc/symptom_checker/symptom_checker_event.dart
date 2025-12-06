part of 'symptom_checker_bloc.dart';

/// Base event class for symptom checker
abstract class SymptomCheckerEvent {}

/// Event triggered when user submits symptoms for analysis
class SymptomSubmitted extends SymptomCheckerEvent {
  final String symptoms;

  SymptomSubmitted({required this.symptoms});
}

/// Event triggered when user sends a chat message
class ChatMessageSent extends SymptomCheckerEvent {
  final String message;

  ChatMessageSent({required this.message});
}

/// Event triggered when user clears the chat
class ChatCleared extends SymptomCheckerEvent {}