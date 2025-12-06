/// Authentication provider types supported by the application
enum AuthProviderType {
  phone('phone', 'Phone Number'),
  email('email', 'Email & Password'),
  google('google', 'Google'),
  biometric('biometric', 'Biometric');

  final String value;
  final String displayName;

  const AuthProviderType(this.value, this.displayName);

  static AuthProviderType fromString(String value) {
    return AuthProviderType.values.firstWhere(
      (type) => type.value == value.toLowerCase(),
      orElse: () => AuthProviderType.email,
    );
  }
}
