import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/health_document.dart';
import '../repositories/medical_records_repository.dart';

class GetDocumentById {
  final MedicalRecordsRepository repository;

  GetDocumentById(this.repository);

  Future<Either<Failure, HealthDocument>> call(String id) {
    return repository.getDocumentById(id);
  }
}
