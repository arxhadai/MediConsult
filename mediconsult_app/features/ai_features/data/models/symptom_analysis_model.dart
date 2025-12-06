import '../../domain/entities/symptom_analysis.dart';
import '../../domain/enums/urgency_level.dart';

/// Model for symptom analysis that can be serialized/deserialized
class SymptomAnalysisModel {
  final String id;
  final String summary;
  final List<String> symptoms;
  final List<String> possibleConditions;
  final UrgencyLevel urgencyLevel;
  final String recommendations;
  final DateTime analyzedAt;

  SymptomAnalysisModel({
    required this.id,
    required this.summary,
    required this.symptoms,
    required this.possibleConditions,
    required this.urgencyLevel,
    required this.recommendations,
    required this.analyzedAt,
  });

  /// Convert model to entity
  SymptomAnalysis toEntity() {
    return SymptomAnalysis(
      id: id,
      summary: summary,
      symptoms: symptoms,
      possibleConditions: possibleConditions,
      urgencyLevel: urgencyLevel,
      recommendations: recommendations,
      analyzedAt: analyzedAt,
    );
  }

  /// Create model from entity
  factory SymptomAnalysisModel.fromEntity(SymptomAnalysis entity) {
    return SymptomAnalysisModel(
      id: entity.id,
      summary: entity.summary,
      symptoms: entity.symptoms,
      possibleConditions: entity.possibleConditions,
      urgencyLevel: entity.urgencyLevel,
      recommendations: entity.recommendations,
      analyzedAt: entity.analyzedAt,
    );
  }

  /// Create model from JSON
  factory SymptomAnalysisModel.fromJson(Map<String, dynamic> json) {
    return SymptomAnalysisModel(
      id: json['id'] as String,
      summary: json['summary'] as String,
      symptoms: List<String>.from(json['symptoms'] as List),
      possibleConditions: List<String>.from(json['possibleConditions'] as List),
      urgencyLevel: _urgencyLevelFromString(json['urgencyLevel'] as String),
      recommendations: json['recommendations'] as String,
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'summary': summary,
      'symptoms': symptoms,
      'possibleConditions': possibleConditions,
      'urgencyLevel': _urgencyLevelToString(urgencyLevel),
      'recommendations': recommendations,
      'analyzedAt': analyzedAt.toIso8601String(),
    };
  }

  /// Helper method to convert string to UrgencyLevel
  static UrgencyLevel _urgencyLevelFromString(String value) {
    switch (value) {
      case 'low':
        return UrgencyLevel.low;
      case 'medium':
        return UrgencyLevel.medium;
      case 'high':
        return UrgencyLevel.high;
      case 'emergency':
        return UrgencyLevel.emergency;
      default:
        return UrgencyLevel.low;
    }
  }

  /// Helper method to convert UrgencyLevel to string
  static String _urgencyLevelToString(UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.low:
        return 'low';
      case UrgencyLevel.medium:
        return 'medium';
      case UrgencyLevel.high:
        return 'high';
      case UrgencyLevel.emergency:
        return 'emergency';
    }
  }
}