import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/symptom_analysis.dart';
import '../../domain/entities/consultation_summary.dart';
import '../../domain/entities/drug_interaction.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/gemini_ai_service.dart';

import '../models/chat_message_model.dart';

/// Implementation of AI repository
@LazySingleton(as: AiRepository)
class AiRepositoryImpl implements AiRepository {
  final GeminiAiService _geminiAiService;

  AiRepositoryImpl(this._geminiAiService);

  @override
  Future<Either<Failure, SymptomAnalysis>> analyzeSymptoms(
      String symptoms) async {
    final result = await _geminiAiService.analyzeSymptoms(symptoms);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, ChatMessage>> sendChatMessage(
      ChatMessage message) async {
    final messageModel = ChatMessageModel.fromEntity(message);
    // In a real implementation, we would pass conversation history
    final emptyHistory = <ChatMessageModel>[];

    final result =
        await _geminiAiService.sendChatMessage(messageModel, emptyHistory);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, ConsultationSummary>> generateSummary(
    String consultationTranscript,
  ) async {
    final result =
        await _geminiAiService.generateSummary(consultationTranscript);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, DrugInteraction>> checkDrugInteractions(
    String drugA,
    String drugB,
  ) async {
    final result = await _geminiAiService.checkDrugInteractions(drugA, drugB);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }
}
