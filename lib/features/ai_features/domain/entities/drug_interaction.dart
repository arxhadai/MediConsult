import 'package:equatable/equatable.dart';
import '../enums/interaction_severity.dart';

/// Entity representing a drug interaction result
class DrugInteraction extends Equatable {
  final String id;
  final String drugA;
  final String drugB;
  final InteractionSeverity severity;
  final String description;
  final String recommendation;
  final DateTime checkedAt;

  const DrugInteraction({
    required this.id,
    required this.drugA,
    required this.drugB,
    required this.severity,
    required this.description,
    required this.recommendation,
    required this.checkedAt,
  });

  @override
  List<Object?> get props => [
        id,
        drugA,
        drugB,
        severity,
        description,
        recommendation,
        checkedAt,
      ];

  DrugInteraction copyWith({
    String? id,
    String? drugA,
    String? drugB,
    InteractionSeverity? severity,
    String? description,
    String? recommendation,
    DateTime? checkedAt,
  }) {
    return DrugInteraction(
      id: id ?? this.id,
      drugA: drugA ?? this.drugA,
      drugB: drugB ?? this.drugB,
      severity: severity ?? this.severity,
      description: description ?? this.description,
      recommendation: recommendation ?? this.recommendation,
      checkedAt: checkedAt ?? this.checkedAt,
    );
  }
}