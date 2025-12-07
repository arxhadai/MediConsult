import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/symptom_analysis_model.dart';
import '../models/consultation_summary_model.dart';
import '../models/drug_interaction_model.dart';
import '../models/chat_message_model.dart';

/// Abstract class for Gemini AI service
abstract class GeminiAiService {
  /// Analyze symptoms using AI
  Future<Either<Failure, SymptomAnalysisModel>> analyzeSymptoms(String symptoms);

  /// Send chat message to AI and get response
  Future<Either<Failure, ChatMessageModel>> sendChatMessage(
    ChatMessageModel message,
    List<ChatMessageModel> history,
  );

  /// Generate consultation summary from transcript
  Future<Either<Failure, ConsultationSummaryModel>> generateSummary(
    String consultationTranscript,
  );

  /// Check drug interactions
  Future<Either<Failure, DrugInteractionModel>> checkDrugInteractions(
    String drugA,
    String drugB,
  );
}