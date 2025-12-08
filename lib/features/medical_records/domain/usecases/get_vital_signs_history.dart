import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vital_signs.dart';
import '../repositories/medical_records_repository.dart';

class GetVitalSignsHistory {
  final MedicalRecordsRepository repository;

  GetVitalSignsHistory(this.repository);

  Future<Either<Failure, List<VitalSigns>>> call(String patientId) {
    return repository.getVitalSignsHistory(patientId);
  }
}
