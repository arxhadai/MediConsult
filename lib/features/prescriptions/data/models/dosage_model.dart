import '../../domain/entities/dosage.dart';

/// Data model for Dosage entity with JSON serialization
class DosageModel extends Dosage {
  const DosageModel({
    required super.amount,
    required super.unit,
  });

  /// Create DosageModel from JSON map
  factory DosageModel.fromJson(Map<String, dynamic> json) {
    return DosageModel(
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }

  /// Convert DosageModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }
}