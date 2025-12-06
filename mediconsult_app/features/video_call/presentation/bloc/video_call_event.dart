part of 'video_call_bloc.dart';

/// Base event class for video call BLoC
abstract class VideoCallEvent {
  const VideoCallEvent();
}

// Public events
class VideoCallInitializeRequested extends VideoCallEvent {
  final String consultationId;
  final bool isVideoCall;
  
  const VideoCallInitializeRequested({
    required this.consultationId,
    required this.isVideoCall,
  });
}

class VideoCallJoinRequested extends VideoCallEvent {
  final String token;
  final String channelName;
  final int uid;
  final bool enableVideo;
  
  const VideoCallJoinRequested({
    required this.token,
    required this.channelName,
    required this.uid,
    required this.enableVideo,
  });
}

class VideoCallLeaveRequested extends VideoCallEvent {
  const VideoCallLeaveRequested();
}

class VideoCallAudioToggled extends VideoCallEvent {
  const VideoCallAudioToggled();
}

class VideoCallVideoToggled extends VideoCallEvent {
  const VideoCallVideoToggled();
}

class VideoCallCameraSwitched extends VideoCallEvent {
  const VideoCallCameraSwitched();
}

class VideoCallEndRequested extends VideoCallEvent {
  final String? notes;
  
  const VideoCallEndRequested({this.notes});
}

// Internal events
class _VideoCallRemoteUserJoined extends VideoCallEvent {
  final int uid;
  
  const _VideoCallRemoteUserJoined(this.uid);
}

class _VideoCallRemoteUserLeft extends VideoCallEvent {
  final int uid;
  
  const _VideoCallRemoteUserLeft(this.uid);
}

class _VideoCallNetworkQualityChanged extends VideoCallEvent {
  final int uid;
  final dynamic quality; // Using dynamic to avoid import issues
  
  const _VideoCallNetworkQualityChanged(this.uid, this.quality);
}

class _VideoCallConnectionStateChanged extends VideoCallEvent {
  final dynamic state; // Using dynamic to avoid import issues
  
  const _VideoCallConnectionStateChanged(this.state);
}

class _VideoCallError extends VideoCallEvent {
  final String message;
  final bool canRetry;
  
  const _VideoCallError(this.message, this.canRetry);
}

class _VideoCallDurationTick extends VideoCallEvent {
  const _VideoCallDurationTick();
}