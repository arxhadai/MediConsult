import 'package:equatable/equatable.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/enums/call_status.dart';
import '../../domain/enums/call_type.dart';
import 'participant_model.dart';
import 'call_quality_model.dart';

class CallSessionModel extends Equatable {
  final String sessionId;
  final String consultationId;
  final String channelName;
  final String token;
  final int uid;
  final CallType callType;
  final CallStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<ParticipantModel> participants;
  final CallQualityModel? localQuality;
  final CallQualityModel? remoteQuality;
  final bool isRecording;
  final String? recordingUrl;
  final String? errorMessage;

  const CallSessionModel({
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

  factory CallSessionModel.fromJson(Map<String, dynamic> json) {
    final participantsJson = json['participants'] as List<dynamic>?;
    final participants = participantsJson
            ?.map((e) => ParticipantModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return CallSessionModel(
      sessionId: json['sessionId'] as String,
      consultationId: json['consultationId'] as String,
      channelName: json['channelName'] as String,
      token: json['token'] as String,
      uid: json['uid'] as int,
      callType: _parseCallType(json['callType'] as String),
      status: _parseCallStatus(json['status'] as String),
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : null,
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      participants: participants,
      localQuality: json['localQuality'] != null
          ? CallQualityModel.fromJson(
              json['localQuality'] as Map<String, dynamic>)
          : null,
      remoteQuality: json['remoteQuality'] != null
          ? CallQualityModel.fromJson(
              json['remoteQuality'] as Map<String, dynamic>)
          : null,
      isRecording: json['isRecording'] as bool? ?? false,
      recordingUrl: json['recordingUrl'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'consultationId': consultationId,
      'channelName': channelName,
      'token': token,
      'uid': uid,
      'callType': _callTypeToString(callType),
      'status': _callStatusToString(status),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'participants': participants.map((e) => e.toJson()).toList(),
      'localQuality': localQuality?.toJson(),
      'remoteQuality': remoteQuality?.toJson(),
      'isRecording': isRecording,
      'recordingUrl': recordingUrl,
      'errorMessage': errorMessage,
    };
  }

  CallSession toEntity() {
    return CallSession(
      sessionId: sessionId,
      consultationId: consultationId,
      channelName: channelName,
      token: token,
      uid: uid,
      callType: callType,
      status: status,
      startTime: startTime,
      endTime: endTime,
      participants: participants.map((e) => e.toEntity()).toList(),
      localQuality: localQuality?.toEntity(),
      remoteQuality: remoteQuality?.toEntity(),
      isRecording: isRecording,
      recordingUrl: recordingUrl,
      errorMessage: errorMessage,
    );
  }

  static CallType _parseCallType(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return CallType.video;
      case 'audio':
        return CallType.audio;
      default:
        return CallType.video;
    }
  }

  static String _callTypeToString(CallType type) {
    switch (type) {
      case CallType.video:
        return 'video';
      case CallType.audio:
        return 'audio';
      case CallType.screenShare:
        return 'screenShare';
    }
  }

  static CallStatus _parseCallStatus(String status) {
    switch (status.toLowerCase()) {
      case 'idle':
        return CallStatus.idle;
      case 'initializing':
        return CallStatus.initializing;
      case 'ready':
        return CallStatus.ready;
      case 'connecting':
        return CallStatus.connecting;
      case 'ringing':
        return CallStatus.ringing;
      case 'connected':
        return CallStatus.connected;
      case 'reconnecting':
        return CallStatus.reconnecting;
      case 'ended':
        return CallStatus.ended;
      case 'failed':
        return CallStatus.failed;
      default:
        return CallStatus.idle;
    }
  }

  static String _callStatusToString(CallStatus status) {
    switch (status) {
      case CallStatus.idle:
        return 'idle';
      case CallStatus.initializing:
        return 'initializing';
      case CallStatus.ready:
        return 'ready';
      case CallStatus.connecting:
        return 'connecting';
      case CallStatus.ringing:
        return 'ringing';
      case CallStatus.connected:
        return 'connected';
      case CallStatus.reconnecting:
        return 'reconnecting';
      case CallStatus.ended:
        return 'ended';
      case CallStatus.failed:
        return 'failed';
    }
  }

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

  CallSessionModel copyWith({
    String? sessionId,
    String? consultationId,
    String? channelName,
    String? token,
    int? uid,
    CallType? callType,
    CallStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    List<ParticipantModel>? participants,
    CallQualityModel? localQuality,
    CallQualityModel? remoteQuality,
    bool? isRecording,
    String? recordingUrl,
    String? errorMessage,
  }) {
    return CallSessionModel(
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
