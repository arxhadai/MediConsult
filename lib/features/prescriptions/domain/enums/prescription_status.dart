enum PrescriptionStatus {
  draft,
  active,
  completed,
  expired,
  cancelled,
}

extension PrescriptionStatusExtension on PrescriptionStatus {
  String get displayName {
    switch (this) {
      case PrescriptionStatus.draft:
        return 'Draft';
      case PrescriptionStatus.active:
        return 'Active';
      case PrescriptionStatus.completed:
        return 'Completed';
      case PrescriptionStatus.expired:
        return 'Expired';
      case PrescriptionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
