import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription.dart';
import '../repositories/prescription_repository.dart';

/// Use case for getting consultation prescriptions
class GetConsultationPrescriptions {
  final PrescriptionRepository repository;

  GetConsultationPrescriptions(this.repository);

  Future<Either<Failure, List<Prescription>>> call(GetConsultationPrescriptionsParams params) {
    return repository.getConsultationPrescriptions(params.consultationId);
  }
}

class GetConsultationPrescriptionsParams extends Equatable {
  final String consultationId;

  const GetConsultationPrescriptionsParams({required this.consultationId});

  @override
  List<Object?> get props => [consultationId];
}