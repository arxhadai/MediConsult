import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/call_status.dart';
import '../enums/call_type.dart';
import 'participant.dart';
import 'call_quality.dart';

part 'call_session.freezed.dart';

/// Entity representing a video call session
@freezed
class CallSession with _$CallSession {
  const factory CallSession({
    required String sessionId,
    required String consultationId,
    required String channelName,
    required String token,
    required int uid,
    required CallType callType,
    @Default(CallStatus.idle) CallStatus status,
    DateTime? startTime,
    DateTime? endTime,
    @Default([]) List<Participant> participants,
    CallQuality? localQuality,
    CallQuality? remoteQuality,
    @Default(false) bool isRecording,
    String? recordingUrl,
    String? errorMessage,
  }) = _CallSession;

  const CallSession._();

  /// Returns call duration, or null if call hasn't started
  Duration? get duration {
    if (startTime == null) return null;
    final end = endTime ?? DateTime.now();
    return end.difference(startTime!);
  }

  /// Check if call is in an active state
  bool get isActive => [
        CallStatus.connecting,
        CallStatus.ringing,
        CallStatus.connected,
        CallStatus.reconnecting,
      ].contains(status);
}