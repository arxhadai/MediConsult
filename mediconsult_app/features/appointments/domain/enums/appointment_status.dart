/// Appointment statuses in the MediConsult system
enum AppointmentStatus {
  pending('pending', 'Pending Confirmation'),
  confirmed('confirmed', 'Confirmed'),
  rescheduled('rescheduled', 'Rescheduled'),
  cancelled('cancelled', 'Cancelled'),
  completed('completed', 'Completed'),
  noShow('no_show', 'No Show');

  final String value;
  final String displayName;

  const AppointmentStatus(this.value, this.displayName);

  static AppointmentStatus fromString(String value) {
    return AppointmentStatus.values.firstWhere(
      (status) => status.value == value.toLowerCase(),
      orElse: () => AppointmentStatus.pending,
    );
  }

  /// Check if appointment is active (can be modified)
  bool get isActive => this == AppointmentStatus.pending || this == AppointmentStatus.confirmed;

  /// Check if appointment is completed
  bool get isCompleted => this == AppointmentStatus.completed || this == AppointmentStatus.noShow;

  /// Check if appointment is cancelled
  bool get isCancelled => this == AppointmentStatus.cancelled;
}
