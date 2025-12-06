import 'package:equatable/equatable.dart';
import '../../domain/enums/participant_role.dart';

/// Entity representing a participant in a video call
class Participant extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final ParticipantRole role;
  final bool isMuted;
  final bool isVideoOff;
  final bool isScreenSharing;

  const Participant({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.role,
    this.isMuted = false,
    this.isVideoOff = false,
    this.isScreenSharing = false,
  });

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

  Participant copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    ParticipantRole? role,
    bool? isMuted,
    bool? isVideoOff,
    bool? isScreenSharing,
  }) {
    return Participant(
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