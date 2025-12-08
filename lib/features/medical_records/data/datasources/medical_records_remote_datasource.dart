import 'package:dartz/dartz.dart';
import '../../domain/enums/record_category.dart';
import '../models/health_document_model.dart';
import '../models/vital_signs_model.dart';

/// Abstract interface for medical records remote data source operations
abstract class MedicalRecordsRemoteDataSource {
  /// Upload a health document
  Future<Either<String, void>> uploadDocument(HealthDocumentModel document);

  /// Get all documents for a patient
  Future<Either<String, List<HealthDocumentModel>>> getAllDocuments(
      String patientId);

  /// Get a specific document by ID
  Future<Either<String, HealthDocumentModel>> getDocumentById(String id);

  /// Get documents by category for a patient
  Future<Either<String, List<HealthDocumentModel>>> getDocumentsByCategory(
      String patientId, RecordCategory category);

  /// Delete a document by ID
  Future<Either<String, void>> deleteDocument(String id);

  /// Share a document with a doctor
  Future<Either<String, void>> shareDocumentWithDoctor(
      String documentId, String doctorId);

  /// Revoke document access from a doctor
  Future<Either<String, void>> revokeDocumentAccess(
      String documentId, String doctorId);

  /// Record vital signs
  Future<Either<String, void>> recordVitalSigns(VitalSignsModel vitalSigns);

  /// Get vital signs history for a patient
  Future<Either<String, List<VitalSignsModel>>> getVitalSignsHistory(
      String patientId);

  /// Get latest vital signs for a patient
  Future<Either<String, VitalSignsModel>> getLatestVitalSigns(String patientId);
}
