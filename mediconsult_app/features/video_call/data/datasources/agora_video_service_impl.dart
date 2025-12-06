import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'agora_video_service.dart';

@LazySingleton(as: AgoraVideoService)
class AgoraVideoServiceImpl implements AgoraVideoService {
  // Agora App ID - Should come from environment config
  static const String _appId = String.fromEnvironment(
    'AGORA_APP_ID',
    defaultValue: 'YOUR_AGORA_APP_ID_HERE',
  );

  RtcEngine? _engine;
  bool _isInitialized = false;
  String? _currentChannel;

  final StreamController<AgoraCallEvent> _eventController =
      StreamController<AgoraCallEvent>.broadcast();

  @override
  Stream<AgoraCallEvent> get callEventStream => _eventController.stream;

  @override
  RtcEngine? get engine => _engine;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<Either<VideoCallFailure, void>> initialize() async {
    if (_isInitialized && _engine != null) {
      return const Right(null);
    }

    try {
      // Create RTC Engine
      _engine = createAgoraRtcEngine();

      await _engine!.initialize(const RtcEngineContext(
        appId: _appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
        logConfig: LogConfig(
          level: LogLevel.logLevelWarn,
          fileSizeInKB: 2048,
        ),
      ));

      // Register event handlers
      _engine!.registerEventHandler(_createEventHandler());

      // Enable video and audio
      await _engine!.enableVideo();
      await _engine!.enableAudio();

      // Set default video configuration for medical consultation
      await setVideoEncoderConfig();

      // Set audio profile for clear voice
      await _engine!.setAudioProfile(
        profile: AudioProfileType.audioProfileSpeechStandard,
        scenario: AudioScenarioType.audioScenarioDefault,
      );

      // Enable audio volume indication (for speaking detection)
      await _engine!.enableAudioVolumeIndication(
        interval: 250,
        smooth: 3,
        reportVad: true,
      );

      _isInitialized = true;
      return const Right(null);
    } catch (e) {
      return Left(VideoCallFailure('Failed to initialize Agora: $e'));
    }
  }

  RtcEngineEventHandler _createEventHandler() {
    return RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        _eventController.add(AgoraJoinedChannel(
          connection.channelId ?? '',
          connection.localUid ?? 0,
          elapsed,
        ));
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        _eventController.add(AgoraUserJoined(remoteUid, elapsed));
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        _eventController.add(AgoraUserOffline(remoteUid, reason));
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        _eventController.add(AgoraLeaveChannel(stats));
      },
      onError: (ErrorCodeType err, String msg) {
        _eventController.add(AgoraError(err, msg));
      },
      onNetworkQuality: (RtcConnection connection, int remoteUid,
          QualityType txQuality, QualityType rxQuality) {
        _eventController.add(AgoraNetworkQuality(
          remoteUid,
          txQuality,
          rxQuality,
        ));
      },
      onConnectionStateChanged: (RtcConnection connection,
          ConnectionStateType state, ConnectionChangedReasonType reason) {
        _eventController.add(AgoraConnectionStateChanged(state, reason));
      },
      onRemoteVideoStateChanged: (
        RtcConnection connection,
        int remoteUid,
        RemoteVideoState state,
        RemoteVideoStateReason reason,
        int elapsed,
      ) {
        _eventController.add(AgoraRemoteVideoStateChanged(
          remoteUid,
          state,
          reason,
        ));
      },
      onRemoteAudioStateChanged: (
        RtcConnection connection,
        int remoteUid,
        RemoteAudioState state,
        RemoteAudioStateReason reason,
        int elapsed,
      ) {
        _eventController.add(AgoraRemoteAudioStateChanged(
          remoteUid,
          state,
          reason,
        ));
      },
      onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
        _eventController.add(const AgoraTokenExpiring());
      },
      onAudioVolumeIndication: (
        RtcConnection connection,
        List<AudioVolumeInfo> speakers,
        int totalVolume,
        int vad,
      ) {
        _eventController.add(AgoraAudioVolumeIndication(speakers, totalVolume));
      },
    );
  }

  @override
  Future<Either<VideoCallFailure, void>> joinChannel({
    required String token,
    required String channelName,
    required int uid,
    required bool enableVideo,
  }) async {
    if (!_isInitialized || _engine == null) {
      return const Left(VideoCallFailure('Agora not initialized'));
    }

    try {
      // Set client role
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      // Enable/disable video based on parameter
      if (enableVideo) {
        await _engine!.enableVideo();
      } else {
        await _engine!.disableVideo();
      }

      // Join channel
      await _engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );

      _currentChannel = channelName;
      return const Right(null);
    } catch (e) {
      return Left(VideoCallFailure('Failed to join channel: $e'));
    }
  }

  @override
  Future<Either<VideoCallFailure, void>> leaveChannel() async {
    if (!_isInitialized || _engine == null) {
      return const Left(VideoCallFailure('Agora not initialized'));
    }

    try {
      await _engine!.leaveChannel();
      _currentChannel = null;
      return const Right(null);
    } catch (e) {
      return Left(VideoCallFailure('Failed to leave channel: $e'));
    }
  }

  @override
  Future<Either<VideoCallFailure, void>> setLocalAudioEnabled(bool enabled) async {
    if (!_isInitialized || _engine == null) {
      return const Left(VideoCallFailure('Agora not initialized'));
    }

    try {
      if (enabled) {
        await _engine!.enableAudio();
      } else {
        await _engine!.disableAudio();
      }
      return const Right(null);
    } catch (e) {
      return Left(VideoCallFailure('Failed to set audio enabled: $e'));
    }
  }

  @override
  Future<Either<VideoCallFailure, void>> setLocalVideoEnabled(bool enabled) async {
    if (!_isInitialized || _engine == null) {
      return const Left(VideoCallFailure('Agora not initialized'));
    }

    try {
      if (enabled) {
        await _engine!.enableVideo();
      } else {
        await _engine!.disableVideo();
      }
      return const Right(null);
    } catch (e) {
      return Left(VideoCallFailure('Failed to set video enabled: $e'));
    }
  }

  @override
  Future<Either<VideoCallFailure, void>> switchCamera() async {
    if (!_isInitialized || _engine == null) {
      return const Left(VideoCallFailure('Agora not initialized'));
    }

    try {
      await _engine!.switchCamera();
      return const Right(null);
    } catch (e) {
      return Left(VideoCallFailure('Failed to switch camera: $e'));
    }
  }

  @override
  Future<Either<VideoCallFailure, void>> setVideoEncoderConfig({
    int width = 1280,
    int height = 720,
    int frameRate = 30,
    int bitrate = 1500,
  }) async {
    if (!_isInitialized || _engine == null) {
      return const Left(VideoCallFailure('Agora not initialized'));
    }

    try {
      await _engine!.setVideoEncoderConfiguration(
        VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: width, height: height),
          frameRate: frameRate,
          bitrate: bitrate,
          orientationMode: OrientationMode.orientationModeAdaptive,
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(VideoCallFailure('Failed to set video encoder config: $e'));
    }
  }

  @override
  Widget getLocalVideoView() {
    if (!_isInitialized || _engine == null) {
      return const SizedBox.shrink();
    }

    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  @override
  Widget getRemoteVideoView(int remoteUid) {
    if (!_isInitialized || _engine == null) {
      return const SizedBox.shrink();
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(uid: remoteUid),
        connection: RtcConnection(
          channelId: _currentChannel ?? '',
          localUid: 0,
        ),
      ),
    );
  }

  @override
  Future<Either<VideoCallFailure, void>> dispose() async {
    if (_engine != null) {
      try {
        await _engine!.leaveChannel();
        await _engine!.release();
        _engine = null;
      } catch (e) {
        // Log error but don't return it since we're disposing
        debugPrint('Error disposing Agora engine: $e');
      }
    }

    await _eventController.close();
    _isInitialized = false;
    _currentChannel = null;
    return const Right(null);
  }
}