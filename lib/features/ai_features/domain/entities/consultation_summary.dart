import 'package:equatable/equatable.dart';

/// Entity representing a consultation summary in SOAP format
class ConsultationSummary extends Equatable {
  final String id;
  final String consultationId;
  final String subject;
  final String objective;
  final String assessment;
  final String plan;
  final List<String> medications;
  final List<String> followUpInstructions;
  final DateTime createdAt;

  const ConsultationSummary({
    required this.id,
    required this.consultationId,
    required this.subject,
    required this.objective,
    required this.assessment,
    required this.plan,
    required this.medications,
    required this.followUpInstructions,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        consultationId,
        subject,
        objective,
        assessment,
        plan,
        medications,
        followUpInstructions,
        createdAt,
      ];

  ConsultationSummary copyWith({
    String? id,
    String? consultationId,
    String? subject,
    String? objective,
    String? assessment,
    String? plan,
    List<String>? medications,
    List<String>? followUpInstructions,
    DateTime? createdAt,
  }) {
    return ConsultationSummary(
      id: id ?? this.id,
      consultationId: consultationId ?? this.consultationId,
      subject: subject ?? this.subject,
      objective: objective ?? this.objective,
      assessment: assessment ?? this.assessment,
      plan: plan ?? this.plan,
      medications: medications ?? this.medications,
      followUpInstructions: followUpInstructions ?? this.followUpInstructions,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}