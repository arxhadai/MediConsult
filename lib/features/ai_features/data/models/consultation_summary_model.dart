import '../../domain/entities/consultation_summary.dart';

/// Model for consultation summary that can be serialized/deserialized
class ConsultationSummaryModel {
  final String id;
  final String consultationId;
  final String subject;
  final String objective;
  final String assessment;
  final String plan;
  final List<String> medications;
  final List<String> followUpInstructions;
  final DateTime createdAt;

  ConsultationSummaryModel({
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

  /// Convert model to entity
  ConsultationSummary toEntity() {
    return ConsultationSummary(
      id: id,
      consultationId: consultationId,
      subject: subject,
      objective: objective,
      assessment: assessment,
      plan: plan,
      medications: medications,
      followUpInstructions: followUpInstructions,
      createdAt: createdAt,
    );
  }

  /// Create model from entity
  factory ConsultationSummaryModel.fromEntity(ConsultationSummary entity) {
    return ConsultationSummaryModel(
      id: entity.id,
      consultationId: entity.consultationId,
      subject: entity.subject,
      objective: entity.objective,
      assessment: entity.assessment,
      plan: entity.plan,
      medications: entity.medications,
      followUpInstructions: entity.followUpInstructions,
      createdAt: entity.createdAt,
    );
  }

  /// Create model from JSON
  factory ConsultationSummaryModel.fromJson(Map<String, dynamic> json) {
    return ConsultationSummaryModel(
      id: json['id'] as String,
      consultationId: json['consultationId'] as String,
      subject: json['subject'] as String,
      objective: json['objective'] as String,
      assessment: json['assessment'] as String,
      plan: json['plan'] as String,
      medications: List<String>.from(json['medications'] as List),
      followUpInstructions: List<String>.from(json['followUpInstructions'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultationId': consultationId,
      'subject': subject,
      'objective': objective,
      'assessment': assessment,
      'plan': plan,
      'medications': medications,
      'followUpInstructions': followUpInstructions,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}