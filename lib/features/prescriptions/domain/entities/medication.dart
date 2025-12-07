import 'package:equatable/equatable.dart';
import 'package:mediconsult/features/prescriptions/domain/enums/medication_form.dart';
import 'package:mediconsult/features/prescriptions/domain/enums/medication_frequency.dart';
import 'package:mediconsult/features/prescriptions/domain/enums/medication_timing.dart';

class Medication extends Equatable {
  final String id;
  final String name;
  final String? genericName;
  final String? brandName;
  final String dosage;
  final MedicationForm form;
  final MedicationFrequency frequency;
  final List<MedicationTiming> timings;
  final int durationDays;
  final int quantity;
  final String? instructions;
  final bool beforeFood;
  final bool isSubstitutionAllowed;
  final String? warnings;

  const Medication({
    required this.id,
    required this.name,
    this.genericName,
    this.brandName,
    required this.dosage,
    required this.form,
    required this.frequency,
    required this.timings,
    required this.durationDays,
    required this.quantity,
    this.instructions,
    this.beforeFood = false,
    this.isSubstitutionAllowed = true,
    this.warnings,
  });

  String get frequencyDisplayText => frequency.displayName;
  String get formDisplayText => form.displayName;
  String get timingDisplayText => timings.map((t) => t.displayName).join(', ');

  Medication copyWith({
    String? id,
    String? name,
    String? genericName,
    String? brandName,
    String? dosage,
    MedicationForm? form,
    MedicationFrequency? frequency,
    List<MedicationTiming>? timings,
    int? durationDays,
    int? quantity,
    String? instructions,
    bool? beforeFood,
    bool? isSubstitutionAllowed,
    String? warnings,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      brandName: brandName ?? this.brandName,
      dosage: dosage ?? this.dosage,
      form: form ?? this.form,
      frequency: frequency ?? this.frequency,
      timings: timings ?? this.timings,
      durationDays: durationDays ?? this.durationDays,
      quantity: quantity ?? this.quantity,
      instructions: instructions ?? this.instructions,
      beforeFood: beforeFood ?? this.beforeFood,
      isSubstitutionAllowed:
          isSubstitutionAllowed ?? this.isSubstitutionAllowed,
      warnings: warnings ?? this.warnings,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, dosage, form, frequency, timings, durationDays, quantity];
}
