import 'package:dartz/dartz.dart';
import '../models/video_token_response_model.dart';

/// Abstract interface for video call remote data source operations
abstract class VideoCallRemoteDataSource {
  /// Get temporary token for joining a video call
  /// [channelName] - Unique channel identifier
  /// [uid] - User ID requesting the token
  Future<Either<String, VideoTokenResponseModel>> getVideoToken({
    required String channelName,
    required int uid,
  });

  /// Record call session metadata
  /// [sessionId] - Unique session identifier
  /// [duration] - Call duration in seconds
  /// [participants] - List of participant IDs
  Future<Either<String, void>> recordCallSession({
    required String sessionId,
    required int duration,
    required List<String> participants,
  });
}