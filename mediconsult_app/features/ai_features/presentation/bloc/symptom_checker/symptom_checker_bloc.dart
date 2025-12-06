import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/utils/logger.dart';

import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/symptom_analysis.dart';
import '../../../domain/usecases/analyze_symptoms.dart';
import '../../../domain/usecases/send_chat_message.dart';
import '../../../domain/enums/message_role.dart';

part 'symptom_checker_event.dart';
part 'symptom_checker_state.dart';

/// BLoC for symptom checker feature
@injectable
class SymptomCheckerBloc extends Bloc<SymptomCheckerEvent, SymptomCheckerState> {
  static final logger = AppLogger;
  final AnalyzeSymptoms _analyzeSymptoms;
  final SendChatMessage _sendChatMessage;
  
  List<ChatMessage> _chatHistory = [];

  SymptomCheckerBloc(
    this._analyzeSymptoms,
    this._sendChatMessage,
  ) : super(SymptomCheckerInitial()) {
    on<SymptomSubmitted>(_onSymptomSubmitted);
    on<ChatMessageSent>(_onChatMessageSent);
    on<ChatCleared>(_onChatCleared);
  }

  Future<void> _onSymptomSubmitted(
    SymptomSubmitted event,
    Emitter<SymptomCheckerState> emit,
  ) async {
    emit(SymptomCheckerLoading());
    
    try {
      final result = await _analyzeSymptoms(event.symptoms);
      
      result.fold(
        (failure) {
          emit(SymptomCheckerError(
            message: failure.toString()
          ));
        },
        (analysis) {
          emit(SymptomCheckerSuccess(analysis: analysis));
        },
      );
    } catch (e) {
      AppLogger.error('Error in symptom analysis: $e');
      emit(SymptomCheckerError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onChatMessageSent(
    ChatMessageSent event,
    Emitter<SymptomCheckerState> emit,
  ) async {
    try {
      // Add user message to history
      final userMessage = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        role: MessageRole.user,
        content: event.message,
        timestamp: DateTime.now(),
      );
      
      _chatHistory.add(userMessage);
      
      // Send message to AI
      final result = await _sendChatMessage(userMessage);
      
      result.fold(
        (failure) {
          emit(SymptomCheckerError(
            message: failure.toString()
          ));
        },
        (aiMessage) {
          _chatHistory.add(aiMessage);
          
          emit(ChatMessageReceived(
            message: aiMessage,
            chatHistory: List.unmodifiable(_chatHistory),
          ));
        },
      );
    } catch (e) {
      AppLogger.error('Error sending chat message: $e');
      emit(SymptomCheckerError(message: 'Failed to send message'));
    }
  }

  Future<void> _onChatCleared(
    ChatCleared event,
    Emitter<SymptomCheckerState> emit,
  ) async {
    _chatHistory.clear();
    emit(SymptomCheckerInitial());
  }
}