import '../models/health_document_model.dart';
import '../models/vital_signs_model.dart';
import '../../domain/enums/record_category.dart';

/// Abstract interface for medical records local data source operations
abstract class MedicalRecordsLocalDataSource {
  /// Cache a health document locally
  Future<void> cacheDocument(HealthDocumentModel document);

  /// Get cached document by ID
  Future<HealthDocumentModel?> getCachedDocument(String id);

  /// Get all cached documents for a patient
  Future<List<HealthDocumentModel>> getCachedDocuments(String patientId);

  /// Get cached documents by category
  Future<List<HealthDocumentModel>> getCachedDocumentsByCategory(
      String patientId, RecordCategory category);

  /// Delete cached document
  Future<void> deleteCachedDocument(String id);

  /// Clear all cached documents
  Future<void> clearCachedDocuments();

  /// Cache vital signs locally
  Future<void> cacheVitalSigns(VitalSignsModel vitalSigns);

  /// Get cached vital signs history
  Future<List<VitalSignsModel>> getCachedVitalSignsHistory(String patientId);

  /// Get latest cached vital signs
  Future<VitalSignsModel?> getLatestCachedVitalSigns(String patientId);

  /// Clear cached vital signs
  Future<void> clearCachedVitalSigns();
}
