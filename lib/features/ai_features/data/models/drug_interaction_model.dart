import '../../domain/entities/drug_interaction.dart';
import '../../domain/enums/interaction_severity.dart';

/// Model for drug interaction that can be serialized/deserialized
class DrugInteractionModel {
  final String id;
  final String drugA;
  final String drugB;
  final InteractionSeverity severity;
  final String description;
  final String recommendation;
  final DateTime checkedAt;

  DrugInteractionModel({
    required this.id,
    required this.drugA,
    required this.drugB,
    required this.severity,
    required this.description,
    required this.recommendation,
    required this.checkedAt,
  });

  /// Convert model to entity
  DrugInteraction toEntity() {
    return DrugInteraction(
      id: id,
      drugA: drugA,
      drugB: drugB,
      severity: severity,
      description: description,
      recommendation: recommendation,
      checkedAt: checkedAt,
    );
  }

  /// Create model from entity
  factory DrugInteractionModel.fromEntity(DrugInteraction entity) {
    return DrugInteractionModel(
      id: entity.id,
      drugA: entity.drugA,
      drugB: entity.drugB,
      severity: entity.severity,
      description: entity.description,
      recommendation: entity.recommendation,
      checkedAt: entity.checkedAt,
    );
  }

  /// Create model from JSON
  factory DrugInteractionModel.fromJson(Map<String, dynamic> json) {
    return DrugInteractionModel(
      id: json['id'] as String,
      drugA: json['drugA'] as String,
      drugB: json['drugB'] as String,
      severity: _severityFromString(json['severity'] as String),
      description: json['description'] as String,
      recommendation: json['recommendation'] as String,
      checkedAt: DateTime.parse(json['checkedAt'] as String),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'drugA': drugA,
      'drugB': drugB,
      'severity': _severityToString(severity),
      'description': description,
      'recommendation': recommendation,
      'checkedAt': checkedAt.toIso8601String(),
    };
  }

  /// Helper method to convert string to InteractionSeverity
  static InteractionSeverity _severityFromString(String value) {
    switch (value) {
      case 'none':
        return InteractionSeverity.none;
      case 'minor':
        return InteractionSeverity.minor;
      case 'moderate':
        return InteractionSeverity.moderate;
      case 'major':
        return InteractionSeverity.major;
      case 'contraindicated':
        return InteractionSeverity.contraindicated;
      default:
        return InteractionSeverity.none;
    }
  }

  /// Helper method to convert InteractionSeverity to string
  static String _severityToString(InteractionSeverity severity) {
    switch (severity) {
      case InteractionSeverity.none:
        return 'none';
      case InteractionSeverity.minor:
        return 'minor';
      case InteractionSeverity.moderate:
        return 'moderate';
      case InteractionSeverity.major:
        return 'major';
      case InteractionSeverity.contraindicated:
        return 'contraindicated';
    }
  }
}