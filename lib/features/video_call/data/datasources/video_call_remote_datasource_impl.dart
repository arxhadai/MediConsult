import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../models/video_token_response_model.dart';
import 'video_call_remote_datasource.dart';

@LazySingleton(as: VideoCallRemoteDataSource)
class VideoCallRemoteDataSourceImpl implements VideoCallRemoteDataSource {
  final Dio _dio;

  VideoCallRemoteDataSourceImpl(this._dio);

  @override
  Future<Either<String, VideoTokenResponseModel>> getVideoToken({
    required String channelName,
    required int uid,
  }) async {
    try {
      final response = await _dio.post(
        '/video/token',
        data: {
          'channelName': channelName,
          'uid': uid,
        },
      );

      if (response.statusCode == 200) {
        final tokenResponse = VideoTokenResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        return Right(tokenResponse);
      } else {
        return Left('Failed to get video token: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      return Left('Network error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> recordCallSession({
    required String sessionId,
    required int duration,
    required List<String> participants,
  }) async {
    try {
      final response = await _dio.post(
        '/calls/sessions',
        data: {
          'sessionId': sessionId,
          'duration': duration,
          'participants': participants,
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left('Failed to record call session: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      return Left('Network error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }
}