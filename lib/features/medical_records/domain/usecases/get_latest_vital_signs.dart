import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vital_signs.dart';
import '../repositories/medical_records_repository.dart';

class GetLatestVitalSigns {
  final MedicalRecordsRepository repository;

  GetLatestVitalSigns(this.repository);

  Future<Either<Failure, VitalSigns>> call(String patientId) {
    return repository.getLatestVitalSigns(patientId);
  }
}
