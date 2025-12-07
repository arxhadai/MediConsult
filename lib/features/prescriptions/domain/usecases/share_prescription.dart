import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/prescription_repository.dart';

/// Use case for sharing a prescription
@Injectable()
class SharePrescription {
  final PrescriptionRepository repository;

  SharePrescription(this.repository);

  Future<Either<Failure, void>> call(SharePrescriptionParams params) {
    return repository.sharePrescription(
        params.prescriptionId, params.sharingMethods);
  }
}

class SharePrescriptionParams extends Equatable {
  final String prescriptionId;
  final List<String> sharingMethods;

  const SharePrescriptionParams({
    required this.prescriptionId,
    required this.sharingMethods,
  });

  @override
  List<Object?> get props => [prescriptionId, sharingMethods];
}
