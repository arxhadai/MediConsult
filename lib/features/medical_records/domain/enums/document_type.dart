enum DocumentType {
  labReport,
  prescription,
  xray,
  mri,
  ctScan,
  ultrasound,
  ecg,
  bloodTest,
  vaccination,
  insurance,
  dischargeSummary,
  doctorNote,
  other,
}

extension DocumentTypeExtension on DocumentType {
  String get displayName {
    switch (this) {
      case DocumentType.labReport:
        return 'Lab Report';
      case DocumentType.prescription:
        return 'Prescription';
      case DocumentType.xray:
        return 'X-Ray';
      case DocumentType.mri:
        return 'MRI';
      case DocumentType.ctScan:
        return 'CT Scan';
      case DocumentType.ultrasound:
        return 'Ultrasound';
      case DocumentType.ecg:
        return 'ECG';
      case DocumentType.bloodTest:
        return 'Blood Test';
      case DocumentType.vaccination:
        return 'Vaccination Record';
      case DocumentType.insurance:
        return 'Insurance Document';
      case DocumentType.dischargeSummary:
        return 'Discharge Summary';
      case DocumentType.doctorNote:
        return 'Doctor Note';
      case DocumentType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case DocumentType.labReport:
      case DocumentType.bloodTest:
        return '🧪';
      case DocumentType.prescription:
        return '💊';
      case DocumentType.xray:
      case DocumentType.mri:
      case DocumentType.ctScan:
      case DocumentType.ultrasound:
        return '📷';
      case DocumentType.ecg:
        return '❤️';
      case DocumentType.vaccination:
        return '💉';
      case DocumentType.insurance:
        return '📋';
      case DocumentType.dischargeSummary:
      case DocumentType.doctorNote:
        return '📝';
      case DocumentType.other:
        return '📄';
    }
  }
}
