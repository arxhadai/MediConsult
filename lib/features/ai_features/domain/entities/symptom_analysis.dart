import 'package:equatable/equatable.dart';
import '../enums/urgency_level.dart';

/// Entity representing a symptom analysis result
class SymptomAnalysis extends Equatable {
  final String id;
  final String summary;
  final List<String> symptoms;
  final List<String> possibleConditions;
  final UrgencyLevel urgencyLevel;
  final String recommendations;
  final DateTime analyzedAt;

  const SymptomAnalysis({
    required this.id,
    required this.summary,
    required this.symptoms,
    required this.possibleConditions,
    required this.urgencyLevel,
    required this.recommendations,
    required this.analyzedAt,
  });

  @override
  List<Object?> get props => [
        id,
        summary,
        symptoms,
        possibleConditions,
        urgencyLevel,
        recommendations,
        analyzedAt,
      ];

  SymptomAnalysis copyWith({
    String? id,
    String? summary,
    List<String>? symptoms,
    List<String>? possibleConditions,
    UrgencyLevel? urgencyLevel,
    String? recommendations,
    DateTime? analyzedAt,
  }) {
    return SymptomAnalysis(
      id: id ?? this.id,
      summary: summary ?? this.summary,
      symptoms: symptoms ?? this.symptoms,
      possibleConditions: possibleConditions ?? this.possibleConditions,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      recommendations: recommendations ?? this.recommendations,
      analyzedAt: analyzedAt ?? this.analyzedAt,
    );
  }
}