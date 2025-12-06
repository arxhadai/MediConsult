import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_call_repository.dart';

/// Use case for switching camera
class SwitchCamera {
  final VideoCallRepository repository;

  SwitchCamera(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.switchCamera();
  }
}