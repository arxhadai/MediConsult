/// API endpoint constants
class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://api.mediconsult.com/v1';
  static const String agoraBaseUrl = 'https://api.agora.io/v1';
  
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  
  // User
  static const String userProfile = '/user/profile';
  static const String updateUserProfile = '/user/profile';
  
  // Consultations
  static const String consultations = '/consultations';
  static const String consultationById = '/consultations/{id}';
  
  // Video Calls
  static const String videoCallToken = '/video/token';
  static const String callSessions = '/calls/sessions';
  
  // Appointments
  static const String appointments = '/appointments';
  static const String appointmentById = '/appointments/{id}';
  
  // Medical Records
  static const String medicalRecords = '/records';
  static const String recordById = '/records/{id}';
  
  // Prescriptions
  static const String prescriptions = '/prescriptions';
  static const String prescriptionById = '/prescriptions/{id}';
}