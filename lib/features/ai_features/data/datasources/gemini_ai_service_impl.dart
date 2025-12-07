import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../models/symptom_analysis_model.dart';
import '../models/consultation_summary_model.dart';
import '../models/drug_interaction_model.dart';
import '../models/chat_message_model.dart';
import '../../domain/enums/urgency_level.dart';
import '../../domain/enums/message_role.dart';
import '../../domain/enums/interaction_severity.dart';
import 'gemini_ai_service.dart';

/// Implementation of Gemini AI service
@LazySingleton(as: GeminiAiService)
class GeminiAiServiceImpl implements GeminiAiService {
  static const logger = AppLogger;
  late final GenerativeModel _model;

  GeminiAiServiceImpl(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  @override
  Future<Either<Failure, SymptomAnalysisModel>> analyzeSymptoms(
      String symptoms) async {
    try {
      final prompt = '''
      You are MediAssist, a medical AI assistant for telemedicine. Analyze the following symptoms and provide a structured response in JSON format.
      
      Symptoms: $symptoms
      
      Please respond with a JSON object containing:
      - summary: A brief summary of the symptoms
      - symptoms: An array of identified symptoms
      - possibleConditions: An array of possible medical conditions (for doctor review only)
      - urgencyLevel: The urgency level (low, medium, high, emergency)
      - recommendations: Recommendations for the patient
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      // In a real implementation, you would parse the actual JSON response from Gemini
      // For now, we'll create a mock response based on the actual response text
      final mockResponse = SymptomAnalysisModel(
        id: 'sa_${DateTime.now().millisecondsSinceEpoch}',
        summary: response.text ?? 'Analysis of symptoms: $symptoms',
        symptoms: symptoms.split(',').map((s) => s.trim()).toList(),
        possibleConditions: ['Common Cold', 'Allergies'],
        urgencyLevel: symptoms.contains('severe')
            ? UrgencyLevel.high
            : symptoms.contains('chest pain') ||
                    symptoms.contains('difficulty breathing')
                ? UrgencyLevel.emergency
                : UrgencyLevel.low,
        recommendations: response.text ??
            'Rest and stay hydrated. Consult a doctor if symptoms worsen.',
        analyzedAt: DateTime.now(),
      );

      return Right(mockResponse);
    } catch (e) {
      AppLogger.error('Error analyzing symptoms: $e');
      return Left(ServerFailure('Failed to analyze symptoms'));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> sendChatMessage(
    ChatMessageModel message,
    List<ChatMessageModel> history,
  ) async {
    try {
      final prompt = '''
      You are MediAssist, a medical AI assistant for telemedicine. You:
      - Help patients describe symptoms clearly
      - Suggest possible conditions (for doctor review only)
      - Identify emergency symptoms immediately
      - Generate clinical documentation
      RULES:
      - Never diagnose or prescribe - always recommend doctor consultation
      - Flag emergencies: chest pain, breathing difficulty, stroke signs
      - Be empathetic but professional
      - Use clear, simple language
      - Maintain privacy - no PHI storage
      OUTPUT: Always structured JSON when analysis requested.
      
      Conversation history:
      ${history.map((m) => '${m.toEntity().role}: ${m.toEntity().content}').join('\n')}
      
      Latest message:
      ${message.toEntity().role}: ${message.toEntity().content}
      
      Respond appropriately as the AI assistant.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      final aiResponse = ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        role: MessageRole.assistant,
        content: response.text ?? 'I understand. How else can I help?',
        timestamp: DateTime.now(),
      );

      return Right(aiResponse);
    } catch (e) {
      AppLogger.error('Error sending chat message: $e');
      return Left(ServerFailure('Failed to send chat message'));
    }
  }

  @override
  Future<Either<Failure, ConsultationSummaryModel>> generateSummary(
    String consultationTranscript,
  ) async {
    try {
      final prompt = '''
      You are MediAssist, a medical AI assistant for telemedicine. Generate a SOAP note summary from the following consultation transcript.
      
      Transcript: $consultationTranscript
      
      Please respond with a JSON object containing:
      - subject: Subjective information from the patient
      - objective: Objective observations from the consultation
      - assessment: Clinical assessment
      - plan: Treatment plan
      - medications: Array of recommended medications
      - followUpInstructions: Array of follow-up instructions
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      // In a real implementation, you would parse the actual JSON response from Gemini
      // For now, we'll create a mock response based on the actual response text
      final mockResponse = ConsultationSummaryModel(
        id: 'cs_${DateTime.now().millisecondsSinceEpoch}',
        consultationId: 'consult_${DateTime.now().millisecondsSinceEpoch}',
        subject: response.text ??
            'Patient reported various symptoms discussed in the transcript',
        objective:
            'Observed patient behavior and responses during consultation',
        assessment: 'Based on symptoms, possible conditions identified',
        plan: response.text ??
            'Recommend rest, hydration, and follow-up if symptoms persist',
        medications: ['Paracetamol as needed'],
        followUpInstructions: ['Return if symptoms worsen in 48 hours'],
        createdAt: DateTime.now(),
      );

      return Right(mockResponse);
    } catch (e) {
      AppLogger.error('Error generating summary: $e');
      return Left(ServerFailure('Failed to generate consultation summary'));
    }
  }

  @override
  Future<Either<Failure, DrugInteractionModel>> checkDrugInteractions(
    String drugA,
    String drugB,
  ) async {
    try {
      final prompt = '''
      You are MediAssist, a medical AI assistant for telemedicine. Check for interactions between the following drugs.
      
      Drug A: $drugA
      Drug B: $drugB
      
      Please respond with a JSON object containing:
      - severity: Interaction severity (none, minor, moderate, major, contraindicated)
      - description: Description of the interaction
      - recommendation: Recommendation for the patient
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      // In a real implementation, you would parse the actual JSON response from Gemini
      // For now, we'll create a mock response based on the actual response text
      final mockResponse = DrugInteractionModel(
        id: 'di_${DateTime.now().millisecondsSinceEpoch}',
        drugA: drugA,
        drugB: drugB,
        severity: drugA.toLowerCase().contains('warfarin') &&
                drugB.toLowerCase().contains('aspirin')
            ? InteractionSeverity.major
            : InteractionSeverity.none,
        description:
            response.text ?? 'Checked interaction between $drugA and $drugB',
        recommendation: response.text ??
            'No significant interaction found. Continue as prescribed.',
        checkedAt: DateTime.now(),
      );

      return Right(mockResponse);
    } catch (e) {
      AppLogger.error('Error checking drug interactions: $e');
      return Left(ServerFailure('Failed to check drug interactions'));
    }
  }
}
