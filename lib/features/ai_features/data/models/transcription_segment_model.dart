import '../../domain/entities/transcription_segment.dart';

/// Model for transcription segment that can be serialized/deserialized
class TranscriptionSegmentModel {
  final String id;
  final int speakerId;
  final String speakerName;
  final String text;
  final DateTime startTime;
  final DateTime endTime;
  final double confidence;

  TranscriptionSegmentModel({
    required this.id,
    required this.speakerId,
    required this.speakerName,
    required this.text,
    required this.startTime,
    required this.endTime,
    required this.confidence,
  });

  /// Convert model to entity
  TranscriptionSegment toEntity() {
    return TranscriptionSegment(
      id: id,
      speakerId: speakerId,
      speakerName: speakerName,
      text: text,
      startTime: startTime,
      endTime: endTime,
      confidence: confidence,
    );
  }

  /// Create model from entity
  factory TranscriptionSegmentModel.fromEntity(TranscriptionSegment entity) {
    return TranscriptionSegmentModel(
      id: entity.id,
      speakerId: entity.speakerId,
      speakerName: entity.speakerName,
      text: entity.text,
      startTime: entity.startTime,
      endTime: entity.endTime,
      confidence: entity.confidence,
    );
  }

  /// Create model from JSON
  factory TranscriptionSegmentModel.fromJson(Map<String, dynamic> json) {
    return TranscriptionSegmentModel(
      id: json['id'] as String,
      speakerId: json['speakerId'] as int,
      speakerName: json['speakerName'] as String,
      text: json['text'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      confidence: json['confidence'] as double,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speakerId': speakerId,
      'speakerName': speakerName,
      'text': text,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'confidence': confidence,
    };
  }
}