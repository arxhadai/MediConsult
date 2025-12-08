enum RecordCategory {
  all,
  laboratory,
  imaging,
  prescriptions,
  vaccinations,
  surgeries,
  hospitalRecords,
  insurance,
  other,
}

extension RecordCategoryExtension on RecordCategory {
  String get displayName {
    switch (this) {
      case RecordCategory.all:
        return 'All Records';
      case RecordCategory.laboratory:
        return 'Laboratory';
      case RecordCategory.imaging:
        return 'Imaging';
      case RecordCategory.prescriptions:
        return 'Prescriptions';
      case RecordCategory.vaccinations:
        return 'Vaccinations';
      case RecordCategory.surgeries:
        return 'Surgeries';
      case RecordCategory.hospitalRecords:
        return 'Hospital Records';
      case RecordCategory.insurance:
        return 'Insurance';
      case RecordCategory.other:
        return 'Other';
    }
  }
}
