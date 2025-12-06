import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_call_repository.dart';

/// Use case for ending consultation
class EndConsultation {
  final VideoCallRepository repository;

  EndConsultation(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.endConsultation();
  }
}