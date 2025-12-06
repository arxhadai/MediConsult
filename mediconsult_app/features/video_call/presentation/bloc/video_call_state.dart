part of 'video_call_bloc.dart';

/// Base state class for video call BLoC
abstract class VideoCallState {
  const VideoCallState();
}

/// Initial state
class VideoCallInitial extends VideoCallState {
  const VideoCallInitial();
}

/// Loading state
class VideoCallLoading extends VideoCallState {
  final String message;
  
  const VideoCallLoading({required this.message});
}

/// Ready state - service initialized, permissions granted
class VideoCallReady extends VideoCallState {
  final bool permissionsGranted;
  
  const VideoCallReady({required this.permissionsGranted});
}

/// Active call state
class VideoCallActive extends VideoCallState {
  final dynamic session; // Using dynamic to avoid import issues
  final bool isAudioEnabled;
  final bool isVideoEnabled;
  final bool isFrontCamera;
  final Duration callDuration;
  final dynamic localNetworkQuality; // Using dynamic to avoid import issues
  final dynamic remoteNetworkQuality; // Using dynamic to avoid import issues
  final int? remoteUid;
  
  const VideoCallActive({
    required this.session,
    required this.isAudioEnabled,
    required this.isVideoEnabled,
    required this.isFrontCamera,
    required this.callDuration,
    required this.localNetworkQuality,
    required this.remoteNetworkQuality,
    this.remoteUid,
  });
  
  VideoCallActive copyWith({
    dynamic session,
    bool? isAudioEnabled,
    bool? isVideoEnabled,
    bool? isFrontCamera,
    Duration? callDuration,
    dynamic localNetworkQuality,
    dynamic remoteNetworkQuality,
    int? remoteUid,
  }) {
    return VideoCallActive(
      session: session ?? this.session,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      callDuration: callDuration ?? this.callDuration,
      localNetworkQuality: localNetworkQuality ?? this.localNetworkQuality,
      remoteNetworkQuality: remoteNetworkQuality ?? this.remoteNetworkQuality,
      remoteUid: remoteUid ?? this.remoteUid,
    );
  }
}

/// Ended call state
class VideoCallEnded extends VideoCallState {
  final dynamic session; // Using dynamic to avoid import issues
  final Duration totalDuration;
  final String? notes;
  
  const VideoCallEnded({
    required this.session,
    required this.totalDuration,
    this.notes,
  });
}

/// Error state
class VideoCallFailure extends VideoCallState {
  final String message;
  final bool canRetry;
  
  const VideoCallFailure({
    required this.message,
    required this.canRetry,
  });
}