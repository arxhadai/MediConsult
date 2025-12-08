import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/health_document.dart';
import '../repositories/medical_records_repository.dart';

class UploadDocument {
  final MedicalRecordsRepository repository;

  UploadDocument(this.repository);

  Future<Either<Failure, void>> call(HealthDocument document) {
    return repository.uploadDocument(document);
  }
}
