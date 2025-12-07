import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/call_session.dart';
import '../repositories/video_call_repository.dart';

/// Parameters for joining a video call
class JoinCallParams extends Equatable {
  final String token;
  final String channelName;
  final int uid;
  final bool enableVideo;

  const JoinCallParams({
    required this.token,
    required this.channelName,
    required this.uid,
    required this.enableVideo,
  });

  @override
  List<Object?> get props => [token, channelName, uid, enableVideo];
}

/// Use case for joining a video call
@Injectable()
class JoinVideoCall {
  final VideoCallRepository repository;

  JoinVideoCall(this.repository);

  Future<Either<Failure, CallSession>> call(JoinCallParams params) async {
    return await repository.joinCall(
      token: params.token,
      channelName: params.channelName,
      uid: params.uid,
      enableVideo: params.enableVideo,
    );
  }
}
