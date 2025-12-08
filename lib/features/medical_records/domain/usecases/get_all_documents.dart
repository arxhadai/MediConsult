import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/health_document.dart';
import '../repositories/medical_records_repository.dart';

class GetAllDocuments {
  final MedicalRecordsRepository repository;

  GetAllDocuments(this.repository);

  Future<Either<Failure, List<HealthDocument>>> call(String patientId) {
    return repository.getAllDocuments(patientId);
  }
}
