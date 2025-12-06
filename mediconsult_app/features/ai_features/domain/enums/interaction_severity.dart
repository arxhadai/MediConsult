/// Enum representing the severity of drug interactions
enum InteractionSeverity {
  /// No significant interaction
  none,

  /// Minor interaction - monitor patient
  minor,

  /// Moderate interaction - adjust dosage/avoid
  moderate,

  /// Major interaction - avoid combination
  major,

  /// Contraindicated - dangerous combination
  contraindicated,
}