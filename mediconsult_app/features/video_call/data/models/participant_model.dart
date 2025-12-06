import 'package:equatable/equatable.dart';
import '../../domain/entities/participant.dart';
import '../../domain/enums/participant_role.dart';

class ParticipantModel extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final ParticipantRole role;
  final bool isMuted;
  final bool isVideoOff;
  final bool isScreenSharing;

  const ParticipantModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.role,
    this.isMuted = false,
    this.isVideoOff = false,
    this.isScreenSharing = false,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role: _parseRole(json['role'] as String),
      isMuted: json['isMuted'] as bool? ?? false,
      isVideoOff: json['isVideoOff'] as bool? ?? false,
      isScreenSharing: json['isScreenSharing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'role': _roleToString(role),
      'isMuted': isMuted,
      'isVideoOff': isVideoOff,
      'isScreenSharing': isScreenSharing,
    };
  }

  Participant toEntity() {
    return Participant(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      role: role,
      isMuted: isMuted,
      isVideoOff: isVideoOff,
      isScreenSharing: isScreenSharing,
    );
  }

  static ParticipantRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'patient':
        return ParticipantRole.patient;
      case 'doctor':
        return ParticipantRole.doctor;
      case 'admin':
        return ParticipantRole.admin;
      default:
        return ParticipantRole.patient;
    }
  }

  static String _roleToString(ParticipantRole role) {
    switch (role) {
      case ParticipantRole.patient:
        return 'patient';
      case ParticipantRole.doctor:
        return 'doctor';
      case ParticipantRole.admin:
        return 'admin';
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        role,
        isMuted,
        isVideoOff,
        isScreenSharing,
      ];

  ParticipantModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    ParticipantRole? role,
    bool? isMuted,
    bool? isVideoOff,
    bool? isScreenSharing,
  }) {
    return ParticipantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isMuted: isMuted ?? this.isMuted,
      isVideoOff: isVideoOff ?? this.isVideoOff,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
    );
  }
}