import 'package:equatable/equatable.dart';
import '../../domain/enums/network_quality.dart';

/// Entity representing the quality metrics of a video call
class CallQuality extends Equatable {
  final NetworkQuality audioQuality;
  final NetworkQuality videoQuality;
  final int latencyMs; // Round-trip time in milliseconds
  final int packetLoss; // Packet loss percentage
  final int bitrate; // Current bitrate in kbps
  final int fps; // Frames per second

  const CallQuality({
    required this.audioQuality,
    required this.videoQuality,
    required this.latencyMs,
    required this.packetLoss,
    required this.bitrate,
    required this.fps,
  });

  @override
  List<Object?> get props => [
        audioQuality,
        videoQuality,
        latencyMs,
        packetLoss,
        bitrate,
        fps,
      ];

  CallQuality copyWith({
    NetworkQuality? audioQuality,
    NetworkQuality? videoQuality,
    int? latencyMs,
    int? packetLoss,
    int? bitrate,
    int? fps,
  }) {
    return CallQuality(
      audioQuality: audioQuality ?? this.audioQuality,
      videoQuality: videoQuality ?? this.videoQuality,
      latencyMs: latencyMs ?? this.latencyMs,
      packetLoss: packetLoss ?? this.packetLoss,
      bitrate: bitrate ?? this.bitrate,
      fps: fps ?? this.fps,
    );
  }
}