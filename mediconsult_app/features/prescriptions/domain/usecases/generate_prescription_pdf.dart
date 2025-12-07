import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription.dart';
import '../repositories/prescription_repository.dart';

/// Use case for generating prescription PDF
class GeneratePrescriptionPdf {
  final PrescriptionRepository repository;

  GeneratePrescriptionPdf(this.repository);

  Future<Either<Failure, String>> call(GeneratePrescriptionPdfParams params) {
    return repository.generatePrescriptionPdf(params.prescription);
  }
}

class GeneratePrescriptionPdfParams extends Equatable {
  final Prescription prescription;

  const GeneratePrescriptionPdfParams({required this.prescription});

  @override
  List<Object?> get props => [prescription];
}