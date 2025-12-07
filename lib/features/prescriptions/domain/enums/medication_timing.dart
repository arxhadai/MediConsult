enum MedicationTiming {
  morning,
  afternoon,
  evening,
  night,
  beforeBreakfast,
  afterBreakfast,
  beforeLunch,
  afterLunch,
  beforeDinner,
  afterDinner,
  bedtime,
  emptyStomach,
  withFood,
}

extension MedicationTimingExtension on MedicationTiming {
  String get displayName {
    switch (this) {
      case MedicationTiming.morning:
        return 'Morning';
      case MedicationTiming.afternoon:
        return 'Afternoon';
      case MedicationTiming.evening:
        return 'Evening';
      case MedicationTiming.night:
        return 'Night';
      case MedicationTiming.beforeBreakfast:
        return 'Before breakfast';
      case MedicationTiming.afterBreakfast:
        return 'After breakfast';
      case MedicationTiming.beforeLunch:
        return 'Before lunch';
      case MedicationTiming.afterLunch:
        return 'After lunch';
      case MedicationTiming.beforeDinner:
        return 'Before dinner';
      case MedicationTiming.afterDinner:
        return 'After dinner';
      case MedicationTiming.bedtime:
        return 'At bedtime';
      case MedicationTiming.emptyStomach:
        return 'On empty stomach';
      case MedicationTiming.withFood:
        return 'With food';
    }
  }
}
