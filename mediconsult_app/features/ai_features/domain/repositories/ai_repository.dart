import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_message.dart';
import '../entities/symptom_analysis.dart';
import '../entities/consultation_summary.dart';
import '../entities/drug_interaction.dart';

/// Repository interface for AI features
abstract class AiRepository {
  /// Analyze symptoms and return analysis result
  Future<Either<Failure, SymptomAnalysis>> analyzeSymptoms(String symptoms);

  /// Send a message in the chat and get AI response
  Future<Either<Failure, ChatMessage>> sendChatMessage(ChatMessage message);

  /// Generate a consultation summary in SOAP format
  Future<Either<Failure, ConsultationSummary>> generateSummary(
    String consultationTranscript,
  );

  /// Check for drug interactions between two medications
  Future<Either<Failure, DrugInteraction>> checkDrugInteractions(
    String drugA,
    String drugB,
  );
}