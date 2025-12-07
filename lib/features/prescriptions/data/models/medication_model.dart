import '../../domain/entities/medication.dart';
import '../../domain/enums/medication_frequency.dart';
import '../../domain/enums/medication_timing.dart';
import '../../domain/enums/medication_form.dart';

/// Data model for Medication entity with JSON serialization
class MedicationModel extends Medication {
  const MedicationModel({
    required super.id,
    required super.name,
    super.genericName,
    super.brandName,
    required super.dosage,
    required super.form,
    required super.frequency,
    required super.timings,
    required super.durationDays,
    required super.quantity,
    super.instructions,
    super.beforeFood = false,
    super.isSubstitutionAllowed = true,
    super.warnings,
  });

  /// Create MedicationModel from JSON map
  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    // Parse timings from JSON
    List<MedicationTiming> timings = [];
    if (json['timings'] != null) {
      timings = (json['timings'] as List)
          .map((timing) => MedicationTiming.values
              .firstWhere((element) => element.name == timing))
          .toList();
    }

    return MedicationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      genericName: json['genericName'] as String?,
      brandName: json['brandName'] as String?,
      dosage: json['dosage'] as String,
      form: MedicationForm.values
          .firstWhere((element) => element.name == json['form']),
      frequency: MedicationFrequency.values
          .firstWhere((element) => element.name == json['frequency']),
      timings: timings,
      durationDays: json['durationDays'] as int,
      quantity: json['quantity'] as int,
      instructions: json['instructions'] as String?,
      beforeFood: json['beforeFood'] as bool? ?? false,
      isSubstitutionAllowed: json['isSubstitutionAllowed'] as bool? ?? true,
      warnings: json['warnings'] as String?,
    );
  }

  /// Convert MedicationModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genericName': genericName,
      'brandName': brandName,
      'dosage': dosage,
      'form': form.name,
      'frequency': frequency.name,
      'timings': timings.map((timing) => timing.name).toList(),
      'durationDays': durationDays,
      'quantity': quantity,
      'instructions': instructions,
      'beforeFood': beforeFood,
      'isSubstitutionAllowed': isSubstitutionAllowed,
      'warnings': warnings,
    };
  }
}
