import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/call_session.dart';
import '../entities/participant.dart';

/// Abstract repository for video call operations
abstract class VideoCallRepository {
  /// Initialize the video call service
  Future<Either<Failure, void>> initialize({
    required String appId,
  });

  /// Join a video call session
  Future<Either<Failure, CallSession>> joinCall({
    required String token,
    required String channelName,
    required int uid,
    required bool enableVideo,
  });

  /// Leave the current video call
  Future<Either<Failure, void>> leaveCall();

  /// Toggle audio on/off
  Future<Either<Failure, void>> toggleAudio(bool enabled);

  /// Toggle video on/off
  Future<Either<Failure, void>> toggleVideo(bool enabled);

  /// Switch camera between front and back
  Future<Either<Failure, void>> switchCamera();

  /// End the consultation and trigger summary generation
  Future<Either<Failure, void>> endConsultation();

  /// Get the current call session
  Stream<CallSession> get callSessionStream;

  /// Get participant updates
  Stream<List<Participant>> get participantsStream;
}