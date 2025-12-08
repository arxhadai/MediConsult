import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/health_document.dart';
import '../enums/record_category.dart';
import '../repositories/medical_records_repository.dart';

class GetDocumentsByCategory {
  final MedicalRecordsRepository repository;

  GetDocumentsByCategory(this.repository);

  Future<Either<Failure, List<HealthDocument>>> call(
      String patientId, RecordCategory category) {
    return repository.getDocumentsByCategory(patientId, category);
  }
}
