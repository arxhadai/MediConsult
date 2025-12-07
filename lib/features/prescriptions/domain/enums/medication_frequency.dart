enum MedicationFrequency {
  onceDaily,
  twiceDaily,
  thriceDaily,
  fourTimesDaily,
  every4Hours,
  every6Hours,
  every8Hours,
  every12Hours,
  weekly,
  asNeeded,
}

extension MedicationFrequencyExtension on MedicationFrequency {
  String get displayName {
    switch (this) {
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
    }
  }
}
