part of 'video_call_bloc.dart';

/// Base state class for video call BLoC
abstract class VideoCallState extends Equatable {
  const VideoCallState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class VideoCallInitial extends VideoCallState {
  const VideoCallInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
class VideoCallLoading extends VideoCallState {
  const VideoCallLoading();

  @override
  List<Object?> get props => [];
}

/// Initialized state
class VideoCallInitialized extends VideoCallState {
  const VideoCallInitialized();

  @override
  List<Object?> get props => [];
}

/// Active call state
class VideoCallActive extends VideoCallState {
  final dynamic session; // Will be properly typed in the bloc

  const VideoCallActive(this.session);

  @override
  List<Object?> get props => [session];

  @override
  String toString() => 'VideoCallActive { session: $session }';
}

/// Ended call state
class VideoCallEnded extends VideoCallState {
  const VideoCallEnded();

  @override
  List<Object?> get props => [];
}

/// Error state
class VideoCallError extends VideoCallState {
  final String message;

  const VideoCallError(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'VideoCallError { message: $message }';
}