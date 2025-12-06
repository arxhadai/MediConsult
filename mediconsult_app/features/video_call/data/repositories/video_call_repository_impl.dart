import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/participant.dart';
import '../../domain/repositories/video_call_repository.dart';
import '../../domain/enums/call_type.dart';
import '../../domain/enums/call_status.dart';
import '../datasources/agora_video_service.dart';
import '../datasources/video_call_remote_datasource.dart';

@LazySingleton(as: VideoCallRepository)
class VideoCallRepositoryImpl implements VideoCallRepository {
  final AgoraVideoService _agoraService;
  final VideoCallRemoteDataSource _remoteDataSource;

  VideoCallRepositoryImpl(this._agoraService, this._remoteDataSource);

  @override
  Future<Either<Failure, void>> initialize({
    required String appId,
  }) async {
    try {
      final result = await _agoraService.initialize();
      return result.fold(
        (failure) => Left(ServerFailure(failure.message)),
        (success) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to initialize video call: $e'));
    }
  }

  @override
  Future<Either<Failure, CallSession>> joinCall({
    required String token,
    required String channelName,
    required int uid,
    required bool enableVideo,
  }) async {
    try {
      final result = await _agoraService.joinChannel(
        token: token,
        channelName: channelName,
        uid: uid,
        enableVideo: enableVideo,
      );

      return result.fold(
        (failure) => Left(ServerFailure(failure.message)),
        (success) {
          // Create a basic call session for now
          // In a real implementation, this would come from the backend
          return Right(CallSession(
            sessionId: 'session_${DateTime.now().millisecondsSinceEpoch}',
            consultationId: 'consultation_$channelName',
            channelName: channelName,
            token: token,
            uid: uid,
            callType: enableVideo ? CallType.video : CallType.audio,
            status: CallStatus.connected,
            startTime: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to join call: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveCall() async {
    try {
      final result = await _agoraService.leaveChannel();
      return result.fold(
        (failure) => Left(ServerFailure(failure.message)),
        (success) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to leave call: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleAudio(bool enabled) async {
    try {
      final result = await _agoraService.setLocalAudioEnabled(enabled);
      return result.fold(
        (failure) => Left(ServerFailure(failure.message)),
        (success) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to toggle audio: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleVideo(bool enabled) async {
    try {
      final result = await _agoraService.setLocalVideoEnabled(enabled);
      return result.fold(
        (failure) => Left(ServerFailure(failure.message)),
        (success) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to toggle video: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> switchCamera() async {
    try {
      final result = await _agoraService.switchCamera();
      return result.fold(
        (failure) => Left(ServerFailure(failure.message)),
        (success) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to switch camera: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> endConsultation() async {
    try {
      // First leave the call
      final leaveResult = await _agoraService.leaveChannel();
      final leaveSuccess = leaveResult.fold(
        (failure) => false,
        (success) => true,
      );

      if (!leaveSuccess) {
        return Left(ServerFailure('Failed to leave call'));
      }

      // Record call session in backend
      // For now, we'll create a basic call record
      // In a real implementation, this would include actual call details
      final recordResult = await _remoteDataSource.recordCallSession(
        sessionId: 'session_${DateTime.now().millisecondsSinceEpoch}',
        duration: 0, // Would be calculated in real implementation
        participants: [],
      );
      
      return recordResult.fold(
        (error) => Left(ServerFailure(error)),
        (success) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to end consultation: $e'));
    }
  }

  // Streams would typically come from the Agora service
  @override
  Stream<CallSession> get callSessionStream => throw UnimplementedError();

  @override
  Stream<List<Participant>> get participantsStream => throw UnimplementedError();
}