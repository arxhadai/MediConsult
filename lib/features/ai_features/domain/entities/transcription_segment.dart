import 'package:equatable/equatable.dart';

/// Entity representing a transcription segment
class TranscriptionSegment extends Equatable {
  final String id;
  final int speakerId;
  final String speakerName;
  final String text;
  final DateTime startTime;
  final DateTime endTime;
  final double confidence;

  const TranscriptionSegment({
    required this.id,
    required this.speakerId,
    required this.speakerName,
    required this.text,
    required this.startTime,
    required this.endTime,
    required this.confidence,
  });

  @override
  List<Object?> get props => [
        id,
        speakerId,
        speakerName,
        text,
        startTime,
        endTime,
        confidence,
      ];

  TranscriptionSegment copyWith({
    String? id,
    int? speakerId,
    String? speakerName,
    String? text,
    DateTime? startTime,
    DateTime? endTime,
    double? confidence,
  }) {
    return TranscriptionSegment(
      id: id ?? this.id,
      speakerId: speakerId ?? this.speakerId,
      speakerName: speakerName ?? this.speakerName,
      text: text ?? this.text,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      confidence: confidence ?? this.confidence,
    );
  }
}