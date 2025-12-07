import 'package:equatable/equatable.dart';
import '../enums/call_status.dart';
import '../enums/call_type.dart';
import 'participant.dart';
import 'call_quality.dart';

/// Entity representing a video call session
class CallSession extends Equatable {
  final String sessionId;
  final String consultationId;
  final String channelName;
  final String token;
  final int uid;
  final CallType callType;
  final CallStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<Participant> participants;
  final CallQuality? localQuality;
  final CallQuality? remoteQuality;
  final bool isRecording;
  final String? recordingUrl;
  final String? errorMessage;

  const CallSession({
    required this.sessionId,
    required this.consultationId,
    required this.channelName,
    required this.token,
    required this.uid,
    required this.callType,
    this.status = CallStatus.idle,
    this.startTime,
    this.endTime,
    this.participants = const [],
    this.localQuality,
    this.remoteQuality,
    this.isRecording = false,
    this.recordingUrl,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        sessionId,
        consultationId,
        channelName,
        token,
        uid,
        callType,
        status,
        startTime,
        endTime,
        participants,
        localQuality,
        remoteQuality,
        isRecording,
        recordingUrl,
        errorMessage,
      ];

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

  CallSession copyWith({
    String? sessionId,
    String? consultationId,
    String? channelName,
    String? token,
    int? uid,
    CallType? callType,
    CallStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    List<Participant>? participants,
    CallQuality? localQuality,
    CallQuality? remoteQuality,
    bool? isRecording,
    String? recordingUrl,
    String? errorMessage,
  }) {
    return CallSession(
      sessionId: sessionId ?? this.sessionId,
      consultationId: consultationId ?? this.consultationId,
      channelName: channelName ?? this.channelName,
      token: token ?? this.token,
      uid: uid ?? this.uid,
      callType: callType ?? this.callType,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      participants: participants ?? this.participants,
      localQuality: localQuality ?? this.localQuality,
      remoteQuality: remoteQuality ?? this.remoteQuality,
      isRecording: isRecording ?? this.isRecording,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}