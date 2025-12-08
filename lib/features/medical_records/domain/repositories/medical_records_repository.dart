import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/health_document.dart';
import '../entities/vital_signs.dart';
import '../enums/record_category.dart';

abstract class MedicalRecordsRepository {
  // Document operations
  Future<Either<Failure, void>> uploadDocument(HealthDocument document);
  Future<Either<Failure, List<HealthDocument>>> getAllDocuments(
      String patientId);
  Future<Either<Failure, HealthDocument>> getDocumentById(String id);
  Future<Either<Failure, List<HealthDocument>>> getDocumentsByCategory(
      String patientId, RecordCategory category);
  Future<Either<Failure, void>> deleteDocument(String id);
  Future<Either<Failure, void>> shareDocumentWithDoctor(
      String documentId, String doctorId);
  Future<Either<Failure, void>> revokeDocumentAccess(
      String documentId, String doctorId);

  // Vital signs operations
  Future<Either<Failure, void>> recordVitalSigns(VitalSigns vitalSigns);
  Future<Either<Failure, List<VitalSigns>>> getVitalSignsHistory(
      String patientId);
  Future<Either<Failure, VitalSigns>> getLatestVitalSigns(String patientId);
}
