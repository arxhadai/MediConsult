import 'package:equatable/equatable.dart';
import '../enums/document_type.dart';
import '../enums/record_category.dart';
import '../enums/access_level.dart';

class HealthDocument extends Equatable {
  final String id;
  final String patientId;
  final String title;
  final String? description;
  final DocumentType type;
  final RecordCategory category;
  final String fileUrl;
  final String? thumbnailUrl;
  final String fileName;
  final int fileSizeBytes;
  final String mimeType;
  final DateTime documentDate;
  final DateTime uploadedAt;
  final String? uploadedBy;
  final AccessLevel accessLevel;
  final List<String> sharedWithDoctorIds;
  final List<String> tags;
  final Map<String, dynamic>? metadata;

  const HealthDocument({
    required this.id,
    required this.patientId,
    required this.title,
    this.description,
    required this.type,
    required this.category,
    required this.fileUrl,
    this.thumbnailUrl,
    required this.fileName,
    required this.fileSizeBytes,
    required this.mimeType,
    required this.documentDate,
    required this.uploadedAt,
    this.uploadedBy,
    this.accessLevel = AccessLevel.private,
    this.sharedWithDoctorIds = const [],
    this.tags = const [],
    this.metadata,
  });

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024) {
      return '$fileSizeBytes B';
    } else if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  bool get isImage => mimeType.startsWith('image/');
  bool get isPdf => mimeType == 'application/pdf';

  HealthDocument copyWith({
    String? id,
    String? patientId,
    String? title,
    String? description,
    DocumentType? type,
    RecordCategory? category,
    String? fileUrl,
    String? thumbnailUrl,
    String? fileName,
    int? fileSizeBytes,
    String? mimeType,
    DateTime? documentDate,
    DateTime? uploadedAt,
    String? uploadedBy,
    AccessLevel? accessLevel,
    List<String>? sharedWithDoctorIds,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return HealthDocument(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      fileUrl: fileUrl ?? this.fileUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fileName: fileName ?? this.fileName,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      mimeType: mimeType ?? this.mimeType,
      documentDate: documentDate ?? this.documentDate,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      accessLevel: accessLevel ?? this.accessLevel,
      sharedWithDoctorIds: sharedWithDoctorIds ?? this.sharedWithDoctorIds,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [id, patientId, title, type, category, fileUrl];
}
