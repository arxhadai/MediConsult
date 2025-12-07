import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/medication.dart';
import '../repositories/prescription_repository.dart';

/// Use case for setting medication reminder
@Injectable()
class SetMedicationReminder {
  final PrescriptionRepository repository;

  SetMedicationReminder(this.repository);

  Future<Either<Failure, void>> call(SetMedicationReminderParams params) {
    return repository.setMedicationReminder(
        params.prescriptionId, params.medication);
  }
}

class SetMedicationReminderParams extends Equatable {
  final String prescriptionId;
  final Medication medication;

  const SetMedicationReminderParams({
    required this.prescriptionId,
    required this.medication,
  });

  @override
  List<Object?> get props => [prescriptionId, medication];
}
