import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription.dart';
import '../repositories/prescription_repository.dart';

/// Use case for updating a prescription
class UpdatePrescription {
  final PrescriptionRepository repository;

  UpdatePrescription(this.repository);

  Future<Either<Failure, Prescription>> call(UpdatePrescriptionParams params) {
    return repository.updatePrescription(params.prescription);
  }
}

class UpdatePrescriptionParams extends Equatable {
  final Prescription prescription;

  const UpdatePrescriptionParams({required this.prescription});

  @override
  List<Object?> get props => [prescription];
}