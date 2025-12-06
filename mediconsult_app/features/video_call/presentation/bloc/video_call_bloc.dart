import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/enums/call_status.dart';
import '../../domain/enums/network_quality.dart';
import '../../domain/repositories/video_call_repository.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

@injectable
class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final VideoCallRepository _repository;
  
  StreamSubscription? _callEventSubscription;
  Timer? _durationTimer;

  VideoCallBloc(this._repository) : super(const VideoCallInitial()) {
    on<VideoCallInitializeRequested>(_onInitializeRequested);
    on<VideoCallJoinRequested>(_onJoinRequested);
    on<VideoCallLeaveRequested>(_onLeaveRequested);
    on<VideoCallAudioToggled>(_onAudioToggled);
    on<VideoCallVideoToggled>(_onVideoToggled);
    on<VideoCallCameraSwitched>(_onCameraSwitched);
    on<VideoCallEndRequested>(_onEndRequested);
    on<_VideoCallRemoteUserJoined>(_onRemoteUserJoined);
    on<_VideoCallRemoteUserLeft>(_onRemoteUserLeft);
    on<_VideoCallNetworkQualityChanged>(_onNetworkQualityChanged);
    on<_VideoCallConnectionStateChanged>(_onConnectionStateChanged);
    on<_VideoCallError>(_onError);
    on<_VideoCallDurationTick>(_onDurationTick);
  }

  Future<void> _onInitializeRequested(
    VideoCallInitializeRequested event,
    Emitter<VideoCallState> emit,
  ) async {
    emit(const VideoCallLoading(message: 'Initializing video call...'));

    // In a real implementation, this would initialize with proper parameters
    final result = await _repository.initialize(appId: '');

    result.fold(
      (failure) => emit(const VideoCallFailure(
        message: 'Failed to initialize video call',
        canRetry: true,
      )),
      (session) {
        _subscribeToCallEvents();
        emit(const VideoCallReady(
          permissionsGranted: false,
        ));
      },
    );
  }

  Future<void> _onJoinRequested(
    VideoCallJoinRequested event,
    Emitter<VideoCallState> emit,
  ) async {
    final currentState = state;
    if (currentState is! VideoCallReady) return;

    emit(const VideoCallLoading(message: 'Joining call...'));

    final result = await _repository.joinCall(
      token: event.token,
      channelName: event.channelName,
      uid: event.uid,
      enableVideo: event.enableVideo,
    );

    result.fold(
      (failure) => emit(const VideoCallFailure(
        message: 'Failed to join call',
        canRetry: true,
      )),
      (session) {
        _startDurationTimer();
        emit(VideoCallActive(
          session: session.copyWith(
            status: CallStatus.connecting,
            startTime: DateTime.now(),
          ),
          isAudioEnabled: true,
          isVideoEnabled: event.enableVideo,
          isFrontCamera: true,
          callDuration: Duration.zero,
          localNetworkQuality: NetworkQuality.unknown,
          remoteNetworkQuality: NetworkQuality.unknown,
        ));
      },
    );
  }

  Future<void> _onLeaveRequested(
    VideoCallLeaveRequested event,
    Emitter<VideoCallState> emit,
  ) async {
    _stopDurationTimer();
    await _repository.leaveCall();

    final currentState = state;
    if (currentState is VideoCallActive) {
      emit(VideoCallEnded(
        session: currentState.session.copyWith(
          status: CallStatus.ended,
          endTime: DateTime.now(),
        ),
        totalDuration: currentState.callDuration,
      ));
    }
  }

  Future<void> _onAudioToggled(
    VideoCallAudioToggled event,
    Emitter<VideoCallState> emit,
  ) async {
    final currentState = state;
    if (currentState is! VideoCallActive) return;

    final newAudioState = !currentState.isAudioEnabled;
    await _repository.toggleAudio(newAudioState);

    emit(currentState.copyWith(isAudioEnabled: newAudioState));
  }

  Future<void> _onVideoToggled(
    VideoCallVideoToggled event,
    Emitter<VideoCallState> emit,
  ) async {
    final currentState = state;
    if (currentState is! VideoCallActive) return;

    final newVideoState = !currentState.isVideoEnabled;
    await _repository.toggleVideo(newVideoState);

    emit(currentState.copyWith(isVideoEnabled: newVideoState));
  }

  Future<void> _onCameraSwitched(
    VideoCallCameraSwitched event,
    Emitter<VideoCallState> emit,
  ) async {
    final currentState = state;
    if (currentState is! VideoCallActive) return;

    await _repository.switchCamera();

    emit(currentState.copyWith(isFrontCamera: !currentState.isFrontCamera));
  }

  Future<void> _onEndRequested(
    VideoCallEndRequested event,
    Emitter<VideoCallState> emit,
  ) async {
    _stopDurationTimer();

    final currentState = state;
    if (currentState is! VideoCallActive) return;

    emit(const VideoCallLoading(message: 'Ending consultation...'));

    await _repository.endConsultation();

    emit(VideoCallEnded(
      session: currentState.session.copyWith(
        status: CallStatus.ended,
        endTime: DateTime.now(),
      ),
      totalDuration: currentState.callDuration,
      notes: event.notes,
    ));
  }

  void _onRemoteUserJoined(
    _VideoCallRemoteUserJoined event,
    Emitter<VideoCallState> emit,
  ) {
    final currentState = state;
    if (currentState is! VideoCallActive) return;

    emit(currentState.copyWith(
      remoteUid: event.uid,
      session: currentState.session.copyWith(status: CallStatus.connected),
    ));
  }

  void _onRemoteUserLeft(
    _VideoCallRemoteUserLeft event,
    Emitter<VideoCallState> emit,
  ) {
    final currentState = state;
    if (currentState is! VideoCallActive) return;

    // Remote user left - either call ended or connection issue
    emit(currentState.copyWith(
      remoteUid: null,
      session: currentState.session.copyWith(status: CallStatus.ringing),
    ));
  }

  void _onNetworkQualityChanged(
    _VideoCallNetworkQualityChanged event,
    Emitter<VideoCallState> emit,
  ) {
    final currentState = state;
    if (currentState is! VideoCallActive) return;

    if (event.uid == 0) {
      // Local user network quality
      emit(currentState.copyWith(localNetworkQuality: event.quality));
    } else {
      // Remote user network quality
      emit(currentState.copyWith(remoteNetworkQuality: event.quality));
    }
  }

  void _onConnectionStateChanged(
    _VideoCallConnectionStateChanged event,
    Emitter<VideoCallState> emit,
  ) {
    final currentState = state;
    if (currentState is! VideoCallActive) return;

    emit(currentState.copyWith(
      session: currentState.session.copyWith(status: event.state),
    ));
  }

  void _onError(
    _VideoCallError event,
    Emitter<VideoCallState> emit,
  ) {
    emit(VideoCallFailure(
      message: event.message,
      canRetry: event.canRetry,
    ));
  }

  void _onDurationTick(
    _VideoCallDurationTick event,
    Emitter<VideoCallState> emit,
  ) {
    final currentState = state;
    if (currentState is! VideoCallActive) return;

    emit(currentState.copyWith(
      callDuration: currentState.callDuration + const Duration(seconds: 1),
    ));
  }

  void _subscribeToCallEvents() {
    // In a real implementation, this would subscribe to Agora events
    // For now, we'll simulate with a timer
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(const _VideoCallDurationTick());
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  @override
  Future<void> close() {
    _stopDurationTimer();
    _callEventSubscription?.cancel();
    return super.close();
  }
}