import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/medical_records_repository.dart';

class DeleteDocument {
  final MedicalRecordsRepository repository;

  DeleteDocument(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteDocument(id);
  }
}
