part of 'video_call_bloc.dart';

/// Base event class for video call BLoC
abstract class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the video call service
class InitializeVideoCall extends VideoCallEvent {
  final String appId;

  const InitializeVideoCall({required this.appId});

  @override
  List<Object?> get props => [appId];
}

/// Event to join a video call
class JoinVideoCall extends VideoCallEvent {
  final String token;
  final String channelName;
  final int uid;
  final bool enableVideo;

  const JoinVideoCall({
    required this.token,
    required this.channelName,
    required this.uid,
    required this.enableVideo,
  });

  @override
  List<Object?> get props => [token, channelName, uid, enableVideo];
}

/// Event to leave the current video call
class LeaveVideoCall extends VideoCallEvent {}

/// Event to toggle audio on/off
class ToggleAudio extends VideoCallEvent {
  final bool enabled;

  const ToggleAudio({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Event to toggle video on/off
class ToggleVideo extends VideoCallEvent {
  final bool enabled;

  const ToggleVideo({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Event to switch camera
class SwitchCamera extends VideoCallEvent {}

/// Event to end consultation
class EndConsultation extends VideoCallEvent {}