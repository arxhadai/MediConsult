import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/prescription_repository.dart';
import '../entities/prescription.dart';
import 'prescription_usecase.dart';

/// Use case for creating a prescription
@Injectable()
class CreatePrescription
    implements PrescriptionUseCase<Prescription, CreatePrescriptionParams> {
  final PrescriptionRepository repository;

  CreatePrescription(this.repository);

  @override
  Future<Either<Failure, Prescription>> call(CreatePrescriptionParams params) {
    return repository.createPrescription(params.prescription);
  }
}

class CreatePrescriptionParams extends Equatable {
  final Prescription prescription;

  const CreatePrescriptionParams({required this.prescription});

  @override
  List<Object?> get props => [prescription];
}
