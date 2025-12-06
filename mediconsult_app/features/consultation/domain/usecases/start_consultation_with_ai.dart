import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../video_call/domain/repositories/video_call_repository.dart';
import '../../../ai_features/domain/repositories/transcription_repository.dart';

/// Coordinates starting a consultation with video call and AI transcription
/// This use case integrates Video Call and AI Features modules
class StartConsultationWithAI {
  final VideoCallRepository _videoCallRepository;
  final TranscriptionRepository _transcriptionRepository;

  StartConsultationWithAI(
    this._videoCallRepository,
    this._transcriptionRepository,
  );

  /// Execute the use case
  /// Initializes video call and optionally starts AI transcription
  Future<Either<Failure, void>> call(StartConsultationParams params) async {
    // Initialize video call service
    final initResult = await _videoCallRepository.initialize(
      appId: params.agoraAppId,
    );

    if (initResult.isLeft()) {
      return initResult;
    }

    // Join the video call
    final joinResult = await _videoCallRepository.joinCall(
      token: params.token,
      channelName: params.channelName,
      uid: params.uid,
      enableVideo: params.isVideoCall,
    );

    if (joinResult.isLeft()) {
      return joinResult.map((_) {});
    }

    // Start transcription if doctor and transcription is enabled
    if (params.isDoctor && params.enableTranscription) {
      final transcriptionResult = await _transcriptionRepository.startTranscription();
      
      // Continue even if transcription fails (non-critical feature)
      // Log the failure but don't fail the entire operation
      transcriptionResult.fold(
        (failure) {
          // In production, log this to analytics/crash reporting
          // ignore: avoid_print
          // print('Transcription failed to start: $failure');
        },
        (_) {
          // Transcription started successfully
        },
      );
    }

    return const Right(null);
  }

  /// Ends the consultation, stopping transcription and leaving the call
  Future<Either<Failure, void>> endConsultation() async {
    // Stop transcription first
    await _transcriptionRepository.stopTranscription();

    // End the video call and trigger summary generation
    return _videoCallRepository.endConsultation();
  }
}

/// Parameters for starting a consultation with AI features
class StartConsultationParams extends Equatable {
  final String consultationId;
  final String agoraAppId;
  final String token;
  final String channelName;
  final int uid;
  final bool isVideoCall;
  final bool isDoctor;
  final bool enableTranscription;

  const StartConsultationParams({
    required this.consultationId,
    required this.agoraAppId,
    required this.token,
    required this.channelName,
    required this.uid,
    this.isVideoCall = true,
    this.isDoctor = false,
    this.enableTranscription = true,
  });

  @override
  List<Object?> get props => [
        consultationId,
        agoraAppId,
        token,
        channelName,
        uid,
        isVideoCall,
        isDoctor,
        enableTranscription,
      ];
}
