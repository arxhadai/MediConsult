import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/prescription_repository.dart';

/// Base class for all prescription use cases
abstract class PrescriptionUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case for creating a prescription
class CreatePrescription implements PrescriptionUseCase<Prescription, CreatePrescriptionParams> {
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