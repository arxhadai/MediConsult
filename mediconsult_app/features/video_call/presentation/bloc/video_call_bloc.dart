import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/usecases/initialize_video_call.dart';
import '../../domain/usecases/join_video_call.dart';
import '../../domain/usecases/toggle_audio.dart';
import '../../domain/usecases/toggle_video.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final InitializeVideoCall _initializeVideoCall;
  final JoinVideoCall _joinVideoCall;
  final LeaveVideoCall _leaveVideoCall;
  final ToggleAudio _toggleAudio;
  final ToggleVideo _toggleVideo;
  final SwitchCamera _switchCamera;
  final EndConsultation _endConsultation;

  VideoCallBloc({
    required InitializeVideoCall initializeVideoCall,
    required JoinVideoCall joinVideoCall,
    required LeaveVideoCall leaveVideoCall,
    required ToggleAudio toggleAudio,
    required ToggleVideo toggleVideo,
    required SwitchCamera switchCamera,
    required EndConsultation endConsultation,
  })  : _initializeVideoCall = initializeVideoCall,
        _joinVideoCall = joinVideoCall,
        _leaveVideoCall = leaveVideoCall,
        _toggleAudio = toggleAudio,
        _toggleVideo = toggleVideo,
        _switchCamera = switchCamera,
        _endConsultation = endConsultation,
        super(const VideoCallInitial()) {
    on<InitializeVideoCall>(_onInitializeVideoCall);
    on<JoinVideoCall>(_onJoinVideoCall);
    on<LeaveVideoCall>(_onLeaveVideoCall);
    on<ToggleAudio>(_onToggleAudio);
    on<ToggleVideo>(_onToggleVideo);
    on<SwitchCamera>(_onSwitchCamera);
    on<EndConsultation>(_onEndConsultation);
  }

  Future<void> _onInitializeVideoCall(
    InitializeVideoCall event,
    Emitter<VideoCallState> emit,
  ) async {
    emit(const VideoCallLoading());
    final failureOrSuccess = await _initializeVideoCall.call(
      InitializeParams(appId: event.appId),
    );
    emit(
      failureOrSuccess.fold(
        (failure) => VideoCallError(failure.toString()),
        (_) => const VideoCallInitialized(),
      ),
    );
  }

  Future<void> _onJoinVideoCall(
    JoinVideoCall event,
    Emitter<VideoCallState> emit,
  ) async {
    emit(const VideoCallLoading());
    final failureOrSession = await _joinVideoCall.call(
      JoinCallParams(
        token: event.token,
        channelName: event.channelName,
        uid: event.uid,
        enableVideo: event.enableVideo,
      ),
    );
    emit(
      failureOrSession.fold(
        (failure) => VideoCallError(failure.toString()),
        (session) => VideoCallActive(session),
      ),
    );
  }

  Future<void> _onLeaveVideoCall(
    LeaveVideoCall event,
    Emitter<VideoCallState> emit,
  ) async {
    emit(const VideoCallLoading());
    final failureOrSuccess = await _leaveVideoCall.call();
    emit(
      failureOrSuccess.fold(
        (failure) => VideoCallError(failure.toString()),
        (_) => const VideoCallEnded(),
      ),
    );
  }

  Future<void> _onToggleAudio(
    ToggleAudio event,
    Emitter<VideoCallState> emit,
  ) async {
    final currentState = state;
    if (currentState is VideoCallActive) {
      final failureOrSuccess = await _toggleAudio.call(
        ToggleAudioParams(enabled: event.enabled),
      );
      emit(
        failureOrSuccess.fold(
          (failure) => VideoCallError(failure.toString()),
          (_) => VideoCallActive(
            currentState.session.copyWith(),
          ),
        ),
      );
    }
  }

  Future<void> _onToggleVideo(
    ToggleVideo event,
    Emitter<VideoCallState> emit,
  ) async {
    final currentState = state;
    if (currentState is VideoCallActive) {
      final failureOrSuccess = await _toggleVideo.call(
        ToggleVideoParams(enabled: event.enabled),
      );
      emit(
        failureOrSuccess.fold(
          (failure) => VideoCallError(failure.toString()),
          (_) => VideoCallActive(
            currentState.session.copyWith(),
          ),
        ),
      );
    }
  }

  Future<void> _onSwitchCamera(
    SwitchCamera event,
    Emitter<VideoCallState> emit,
  ) async {
    final currentState = state;
    if (currentState is VideoCallActive) {
      final failureOrSuccess = await _switchCamera.call();
      emit(
        failureOrSuccess.fold(
          (failure) => VideoCallError(failure.toString()),
          (_) => VideoCallActive(
            currentState.session.copyWith(),
          ),
        ),
      );
    }
  }

  Future<void> _onEndConsultation(
    EndConsultation event,
    Emitter<VideoCallState> emit,
  ) async {
    emit(const VideoCallLoading());
    final failureOrSuccess = await _endConsultation.call();
    emit(
      failureOrSuccess.fold(
        (failure) => VideoCallError(failure.toString()),
        (_) => const VideoCallEnded(),
      ),
    );
  }
}