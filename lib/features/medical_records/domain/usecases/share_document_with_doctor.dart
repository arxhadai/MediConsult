import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/medical_records_repository.dart';

class ShareDocumentWithDoctor {
  final MedicalRecordsRepository repository;

  ShareDocumentWithDoctor(this.repository);

  Future<Either<Failure, void>> call(String documentId, String doctorId) {
    return repository.shareDocumentWithDoctor(documentId, doctorId);
  }
}
