import 'package:equatable/equatable.dart';
import '../../domain/entities/call_quality.dart';
import '../../domain/enums/network_quality.dart';

class CallQualityModel extends Equatable {
  final NetworkQuality audioQuality;
  final NetworkQuality videoQuality;
  final int latencyMs;
  final int packetLoss;
  final int bitrate;
  final int fps;

  const CallQualityModel({
    required this.audioQuality,
    required this.videoQuality,
    required this.latencyMs,
    required this.packetLoss,
    required this.bitrate,
    required this.fps,
  });

  factory CallQualityModel.fromJson(Map<String, dynamic> json) {
    return CallQualityModel(
      audioQuality: _parseNetworkQuality(json['audioQuality'] as String),
      videoQuality: _parseNetworkQuality(json['videoQuality'] as String),
      latencyMs: json['latencyMs'] as int,
      packetLoss: json['packetLoss'] as int,
      bitrate: json['bitrate'] as int,
      fps: json['fps'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audioQuality': _networkQualityToString(audioQuality),
      'videoQuality': _networkQualityToString(videoQuality),
      'latencyMs': latencyMs,
      'packetLoss': packetLoss,
      'bitrate': bitrate,
      'fps': fps,
    };
  }

  CallQuality toEntity() {
    return CallQuality(
      audioQuality: audioQuality,
      videoQuality: videoQuality,
      latencyMs: latencyMs,
      packetLoss: packetLoss,
      bitrate: bitrate,
      fps: fps,
    );
  }

  static NetworkQuality _parseNetworkQuality(String quality) {
    switch (quality.toLowerCase()) {
      case 'unknown':
        return NetworkQuality.unknown;
      case 'excellent':
        return NetworkQuality.excellent;
      case 'good':
        return NetworkQuality.good;
      case 'poor':
        return NetworkQuality.poor;
      case 'bad':
        return NetworkQuality.bad;
      case 'verybad':
        return NetworkQuality.veryBad;
      case 'down':
        return NetworkQuality.down;
      default:
        return NetworkQuality.unknown;
    }
  }

  static String _networkQualityToString(NetworkQuality quality) {
    switch (quality) {
      case NetworkQuality.unknown:
        return 'unknown';
      case NetworkQuality.excellent:
        return 'excellent';
      case NetworkQuality.good:
        return 'good';
      case NetworkQuality.poor:
        return 'poor';
      case NetworkQuality.bad:
        return 'bad';
      case NetworkQuality.veryBad:
        return 'verybad';
      case NetworkQuality.down:
        return 'down';
    }
  }

  @override
  List<Object?> get props => [
        audioQuality,
        videoQuality,
        latencyMs,
        packetLoss,
        bitrate,
        fps,
      ];

  CallQualityModel copyWith({
    NetworkQuality? audioQuality,
    NetworkQuality? videoQuality,
    int? latencyMs,
    int? packetLoss,
    int? bitrate,
    int? fps,
  }) {
    return CallQualityModel(
      audioQuality: audioQuality ?? this.audioQuality,
      videoQuality: videoQuality ?? this.videoQuality,
      latencyMs: latencyMs ?? this.latencyMs,
      packetLoss: packetLoss ?? this.packetLoss,
      bitrate: bitrate ?? this.bitrate,
      fps: fps ?? this.fps,
    );
  }
}