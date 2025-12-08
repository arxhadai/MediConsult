import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vital_signs.dart';
import '../repositories/medical_records_repository.dart';

class RecordVitalSigns {
  final MedicalRecordsRepository repository;

  RecordVitalSigns(this.repository);

  Future<Either<Failure, void>> call(VitalSigns vitalSigns) {
    return repository.recordVitalSigns(vitalSigns);
  }
}
