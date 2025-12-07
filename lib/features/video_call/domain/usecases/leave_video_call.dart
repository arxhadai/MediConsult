import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_call_repository.dart';

/// Use case for leaving a video call
@Injectable()
class LeaveVideoCall {
  final VideoCallRepository repository;

  LeaveVideoCall(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.leaveCall();
  }
}
