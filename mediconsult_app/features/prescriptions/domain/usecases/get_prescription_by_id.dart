import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription.dart';
import '../repositories/prescription_repository.dart';
import 'prescription_usecase.dart';

/// Use case for getting a prescription by ID
class GetPrescriptionById implements PrescriptionUseCase<Prescription, GetPrescriptionByIdParams> {
  final PrescriptionRepository repository;

  GetPrescriptionById(this.repository);

  @override
  Future<Either<Failure, Prescription>> call(GetPrescriptionByIdParams params) {
    return repository.getPrescriptionById(params.id);
  }
}

class GetPrescriptionByIdParams extends Equatable {
  final String id;

  const GetPrescriptionByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}