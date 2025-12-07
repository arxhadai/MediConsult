enum MedicationForm {
  tablet,
  capsule,
  syrup,
  suspension,
  injection,
  cream,
  ointment,
  gel,
  drops,
  inhaler,
  patch,
  suppository,
  powder,
  spray,
}

extension MedicationFormExtension on MedicationForm {
  String get displayName {
    switch (this) {
      case MedicationForm.tablet:
        return 'Tablet';
      case MedicationForm.capsule:
        return 'Capsule';
      case MedicationForm.syrup:
        return 'Syrup';
      case MedicationForm.suspension:
        return 'Suspension';
      case MedicationForm.injection:
        return 'Injection';
      case MedicationForm.cream:
        return 'Cream';
      case MedicationForm.ointment:
        return 'Ointment';
      case MedicationForm.gel:
        return 'Gel';
      case MedicationForm.drops:
        return 'Drops';
      case MedicationForm.inhaler:
        return 'Inhaler';
      case MedicationForm.patch:
        return 'Patch';
      case MedicationForm.suppository:
        return 'Suppository';
      case MedicationForm.powder:
        return 'Powder';
      case MedicationForm.spray:
        return 'Spray';
    }
  }
}
