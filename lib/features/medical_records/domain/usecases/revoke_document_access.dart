import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/medical_records_repository.dart';

class RevokeDocumentAccess {
  final MedicalRecordsRepository repository;

  RevokeDocumentAccess(this.repository);

  Future<Either<Failure, void>> call(String documentId, String doctorId) {
    return repository.revokeDocumentAccess(documentId, doctorId);
  }
}
