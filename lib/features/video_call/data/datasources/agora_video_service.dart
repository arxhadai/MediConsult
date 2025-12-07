import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

/// Sealed class for Agora call events
sealed class AgoraCallEvent {
  const AgoraCallEvent();
}

class AgoraJoinedChannel extends AgoraCallEvent {
  final String channel;
  final int uid;
  final int elapsed;
  const AgoraJoinedChannel(this.channel, this.uid, this.elapsed);
}

class AgoraUserJoined extends AgoraCallEvent {
  final int remoteUid;
  final int elapsed;
  const AgoraUserJoined(this.remoteUid, this.elapsed);
}

class AgoraUserOffline extends AgoraCallEvent {
  final int remoteUid;
  final UserOfflineReasonType reason;
  const AgoraUserOffline(this.remoteUid, this.reason);
}

class AgoraLeaveChannel extends AgoraCallEvent {
  final RtcStats stats;
  const AgoraLeaveChannel(this.stats);
}

class AgoraError extends AgoraCallEvent {
  final ErrorCodeType errorCode;
  final String message;
  const AgoraError(this.errorCode, this.message);
}

class AgoraNetworkQuality extends AgoraCallEvent {
  final int uid;
  final QualityType txQuality;
  final QualityType rxQuality;
  const AgoraNetworkQuality(this.uid, this.txQuality, this.rxQuality);
}

class AgoraConnectionStateChanged extends AgoraCallEvent {
  final ConnectionStateType state;
  final ConnectionChangedReasonType reason;
  const AgoraConnectionStateChanged(this.state, this.reason);
}

class AgoraRemoteVideoStateChanged extends AgoraCallEvent {
  final int uid;
  final RemoteVideoState state;
  final RemoteVideoStateReason reason;
  const AgoraRemoteVideoStateChanged(this.uid, this.state, this.reason);
}

class AgoraRemoteAudioStateChanged extends AgoraCallEvent {
  final int uid;
  final RemoteAudioState state;
  final RemoteAudioStateReason reason;
  const AgoraRemoteAudioStateChanged(this.uid, this.state, this.reason);
}

class AgoraTokenExpiring extends AgoraCallEvent {
  const AgoraTokenExpiring();
}

class AgoraAudioVolumeIndication extends AgoraCallEvent {
  final List<AudioVolumeInfo> speakers;
  final int totalVolume;
  const AgoraAudioVolumeIndication(this.speakers, this.totalVolume);
}

/// Video call failure types
class VideoCallFailure {
  final String message;
  final int? code;
  const VideoCallFailure(this.message, [this.code]);
}

/// Abstract interface for Agora video call operations
/// Enables easy testing with mock implementations
abstract class AgoraVideoService {
  /// Initialize Agora RTC Engine
  /// Must be called before any other operations
  Future<Either<VideoCallFailure, void>> initialize();

  /// Join a video call channel
  /// [token] - Temporary token from backend
  /// [channelName] - Unique channel identifier
  /// [uid] - Local user ID
  /// [enableVideo] - Whether to enable video (false for audio-only)
  Future<Either<VideoCallFailure, void>> joinChannel({
    required String token,
    required String channelName,
    required int uid,
    required bool enableVideo,
  });

  /// Leave the current channel
  Future<Either<VideoCallFailure, void>> leaveChannel();

  /// Enable or disable local audio
  Future<Either<VideoCallFailure, void>> setLocalAudioEnabled(bool enabled);

  /// Enable or disable local video
  Future<Either<VideoCallFailure, void>> setLocalVideoEnabled(bool enabled);

  /// Switch between front and back camera
  Future<Either<VideoCallFailure, void>> switchCamera();

  /// Set video encoder configuration
  Future<Either<VideoCallFailure, void>> setVideoEncoderConfig({
    int width = 1280,
    int height = 720,
    int frameRate = 30,
    int bitrate = 1500,
  });

  /// Get local video view widget
  Widget getLocalVideoView();

  /// Get remote video view widget for specific user
  Widget getRemoteVideoView(int remoteUid);

  /// Stream of video call events
  Stream<AgoraCallEvent> get callEventStream;

  /// Current engine instance (for advanced operations)
  RtcEngine? get engine;

  /// Check if engine is initialized
  bool get isInitialized;

  /// Clean up resources
  Future<Either<VideoCallFailure, void>> dispose();
}