import 'package:equatable/equatable.dart';
import '../enums/medication_frequency.dart';
import '../enums/medication_timing.dart';
import '../enums/medication_form.dart';
import 'dosage.dart';

/// Medication entity representing a prescribed medication
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
  final String? sideEffects;

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
    this.sideEffects,
  });

  String get frequencyDisplayText {
    switch (frequency) {
      case MedicationFrequency.onceDaily:
        return 'Once daily';
      case MedicationFrequency.twiceDaily:
        return 'Twice daily';
      case MedicationFrequency.thriceDaily:
        return 'Three times daily';
      case MedicationFrequency.fourTimesDaily:
        return 'Four times daily';
      case MedicationFrequency.every4Hours:
        return 'Every 4 hours';
      case MedicationFrequency.every6Hours:
        return 'Every 6 hours';
      case MedicationFrequency.every8Hours:
        return 'Every 8 hours';
      case MedicationFrequency.every12Hours:
        return 'Every 12 hours';
      case MedicationFrequency.weekly:
        return 'Once weekly';
      case MedicationFrequency.asNeeded:
        return 'As needed (PRN)';
      default:
        return frequency.name;
    }
  }

  String get formDisplayText {
    switch (form) {
      case MedicationForm.tablet:
        return 'Tablet';
      case MedicationForm.capsule:
        return 'Capsule';
      case MedicationForm.syrup:
        return 'Syrup';
      case MedicationForm.injection:
        return 'Injection';
      case MedicationForm.cream:
        return 'Cream';
      case MedicationForm.drops:
        return 'Drops';
      case MedicationForm.inhaler:
        return 'Inhaler';
      default:
        return form.name;
    }
  }

  String get timingDisplayText =>
      timings.map((t) => t.name).join(', ');

  @override
  List<Object?> get props => [
        id,
        name,
        dosage,
        form,
        frequency,
        timings,
        durationDays,
        quantity,
      ];
}