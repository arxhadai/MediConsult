enum AccessLevel {
  private,
  sharedWithDoctor,
  sharedWithAll,
}

extension AccessLevelExtension on AccessLevel {
  String get displayName {
    switch (this) {
      case AccessLevel.private:
        return 'Private';
      case AccessLevel.sharedWithDoctor:
        return 'Shared with Doctor';
      case AccessLevel.sharedWithAll:
        return 'Shared with All Doctors';
    }
  }
}
