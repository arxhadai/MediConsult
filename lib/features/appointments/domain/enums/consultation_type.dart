/// Types of consultations available in MediConsult
enum ConsultationType {
  video('video', 'Video Consultation'),
  chat('chat', 'Chat Consultation'),
  voice('voice', 'Voice Call'),
  inPerson('in_person', 'In-Person Visit');

  final String value;
  final String displayName;

  const ConsultationType(this.value, this.displayName);

  static ConsultationType fromString(String value) {
    return ConsultationType.values.firstWhere(
      (type) => type.value == value.toLowerCase().replaceAll('-', '_'),
      orElse: () => ConsultationType.video,
    );
  }

  /// Check if consultation is virtual
  bool get isVirtual => this == ConsultationType.video || this == ConsultationType.chat || this == ConsultationType.voice;

  /// Check if consultation is in-person
  bool get isInPerson => this == ConsultationType.inPerson;
}
