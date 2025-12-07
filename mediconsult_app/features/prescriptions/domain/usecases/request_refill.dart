import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription.dart';
import '../repositories/prescription_repository.dart';

/// Use case for requesting prescription refill
class RequestRefill {
  final PrescriptionRepository repository;

  RequestRefill(this.repository);

  Future<Either<Failure, Prescription>> call(RequestRefillParams params) {
    return repository.requestRefill(params.prescriptionId);
  }
}

class RequestRefillParams extends Equatable {
  final String prescriptionId;

  const RequestRefillParams({required this.prescriptionId});

  @override
  List<Object?> get props => [prescriptionId];
}