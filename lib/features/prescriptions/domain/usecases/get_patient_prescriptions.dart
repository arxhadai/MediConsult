import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription.dart';
import '../repositories/prescription_repository.dart';

/// Use case for getting patient prescriptions
@Injectable()
class GetPatientPrescriptions {
  final PrescriptionRepository repository;

  GetPatientPrescriptions(this.repository);

  Future<Either<Failure, List<Prescription>>> call(
      GetPatientPrescriptionsParams params) {
    return repository.getPatientPrescriptions(params.patientId);
  }
}

class GetPatientPrescriptionsParams extends Equatable {
  final String patientId;

  const GetPatientPrescriptionsParams({required this.patientId});

  @override
  List<Object?> get props => [patientId];
}
