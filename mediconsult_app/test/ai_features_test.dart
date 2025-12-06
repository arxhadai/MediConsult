import 'package:flutter_test/flutter_test.dart';
import 'package:mediconsult_app/features/ai_features/domain/entities/chat_message.dart';
import 'package:mediconsult_app/features/ai_features/domain/entities/symptom_analysis.dart';
import 'package:mediconsult_app/features/ai_features/domain/entities/consultation_summary.dart';
import 'package:mediconsult_app/features/ai_features/domain/entities/drug_interaction.dart';
import 'package:mediconsult_app/features/ai_features/domain/entities/transcription_segment.dart';
import 'package:mediconsult_app/features/ai_features/domain/enums/urgency_level.dart';
import 'package:mediconsult_app/features/ai_features/domain/enums/message_role.dart';
import 'package:mediconsult_app/features/ai_features/domain/enums/interaction_severity.dart';

void main() {
  group('AI Features Domain Entities', () {
    test('ChatMessage entity can be created', () {
      final chatMessage = ChatMessage(
        id: 'msg_123',
        role: MessageRole.user,
        content: 'Hello, I have a headache',
        timestamp: DateTime.now(),
      );

      expect(chatMessage.id, 'msg_123');
      expect(chatMessage.role, MessageRole.user);
      expect(chatMessage.content, 'Hello, I have a headache');
    });

    test('SymptomAnalysis entity can be created', () {
      final symptomAnalysis = SymptomAnalysis(
        id: 'sa_123',
        summary: 'Patient reports headache',
        symptoms: ['headache'],
        possibleConditions: ['migraine', 'tension headache'],
        urgencyLevel: UrgencyLevel.low,
        recommendations: 'Rest and stay hydrated',
        analyzedAt: DateTime.now(),
      );

      expect(symptomAnalysis.id, 'sa_123');
      expect(symptomAnalysis.urgencyLevel, UrgencyLevel.low);
      expect(symptomAnalysis.symptoms, ['headache']);
    });

    test('ConsultationSummary entity can be created', () {
      final consultationSummary = ConsultationSummary(
        id: 'cs_123',
        consultationId: 'consult_123',
        subject: 'Patient complains of headache',
        objective: 'Patient appears well',
        assessment: 'Likely tension headache',
        plan: 'Prescribe rest and hydration',
        medications: ['paracetamol'],
        followUpInstructions: ['Return if symptoms worsen'],
        createdAt: DateTime.now(),
      );

      expect(consultationSummary.id, 'cs_123');
      expect(consultationSummary.medications, ['paracetamol']);
    });

    test('DrugInteraction entity can be created', () {
      final drugInteraction = DrugInteraction(
        id: 'di_123',
        drugA: 'Warfarin',
        drugB: 'Aspirin',
        severity: InteractionSeverity.major,
        description: 'Increased bleeding risk',
        recommendation: 'Avoid concurrent use',
        checkedAt: DateTime.now(),
      );

      expect(drugInteraction.id, 'di_123');
      expect(drugInteraction.severity, InteractionSeverity.major);
    });

    test('TranscriptionSegment entity can be created', () {
      final transcriptionSegment = TranscriptionSegment(
        id: 'ts_123',
        speakerId: 1,
        speakerName: 'Patient',
        text: 'I have a headache',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(seconds: 5)),
        confidence: 0.95,
      );

      expect(transcriptionSegment.id, 'ts_123');
      expect(transcriptionSegment.speakerName, 'Patient');
      expect(transcriptionSegment.confidence, 0.95);
    });
  });
}