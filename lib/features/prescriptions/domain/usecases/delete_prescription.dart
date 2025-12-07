import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/prescription_repository.dart';

/// Use case for deleting a prescription
@Injectable()
class DeletePrescription {
  final PrescriptionRepository repository;

  DeletePrescription(this.repository);

  Future<Either<Failure, void>> call(DeletePrescriptionParams params) {
    return repository.deletePrescription(params.id);
  }
}

class DeletePrescriptionParams extends Equatable {
  final String id;

  const DeletePrescriptionParams({required this.id});

  @override
  List<Object?> get props => [id];
}
