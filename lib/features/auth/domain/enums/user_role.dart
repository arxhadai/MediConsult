/// User roles in the MediConsult application
enum UserRole {
  patient('patient', 'Patient'),
  doctor('doctor', 'Doctor'),
  admin('admin', 'Administrator');

  final String value;
  final String displayName;

  const UserRole(this.value, this.displayName);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value.toLowerCase(),
      orElse: () => UserRole.patient,
    );
  }
}
