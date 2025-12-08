import 'dart:core';

import '../../domain/entities/health_document.dart';
import '../../domain/enums/document_type.dart';
import '../../domain/enums/record_category.dart';
import '../../domain/enums/access_level.dart';

/// Data model for HealthDocument entity with JSON serialization
class HealthDocumentModel extends HealthDocument {
  const HealthDocumentModel({
    required super.id,
    required super.patientId,
    required super.title,
    super.description,
    required super.type,
    required super.category,
    required super.fileUrl,
    super.thumbnailUrl,
    required super.fileName,
    required super.fileSizeBytes,
    required super.mimeType,
    required super.documentDate,
    required super.uploadedAt,
    super.uploadedBy,
    super.accessLevel = AccessLevel.private,
    super.sharedWithDoctorIds = const [],
    super.tags = const [],
    super.metadata,
  });

  /// Create HealthDocumentModel from JSON map
  factory HealthDocumentModel.fromJson(Map<String, dynamic> json) {
    // Parse sharedWithDoctorIds from JSON
    List<String> sharedWithDoctorIds = [];
    if (json['sharedWithDoctorIds'] != null) {
      sharedWithDoctorIds = (json['sharedWithDoctorIds'] as List)
          .map((id) => id as String)
          .toList();
    }

    // Parse tags from JSON
    List<String> tags = [];
    if (json['tags'] != null) {
      tags = (json['tags'] as List).map((tag) => tag as String).toList();
    }

    return HealthDocumentModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: DocumentType.values
          .firstWhere((element) => element.name == json['type']),
      category: RecordCategory.values
          .firstWhere((element) => element.name == json['category']),
      fileUrl: json['fileUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      fileName: json['fileName'] as String,
      fileSizeBytes: json['fileSizeBytes'] as int,
      mimeType: json['mimeType'] as String,
      documentDate: DateTime.parse(json['documentDate'] as String),
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      uploadedBy: json['uploadedBy'] as String?,
      accessLevel: AccessLevel.values.firstWhere(
          (element) => element.name == json['accessLevel'],
          orElse: () => AccessLevel.private),
      sharedWithDoctorIds: sharedWithDoctorIds,
      tags: tags,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert HealthDocumentModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'title': title,
      'description': description,
      'type': type.name,
      'category': category.name,
      'fileUrl': fileUrl,
      'thumbnailUrl': thumbnailUrl,
      'fileName': fileName,
      'fileSizeBytes': fileSizeBytes,
      'mimeType': mimeType,
      'documentDate': documentDate.toIso8601String(),
      'uploadedAt': uploadedAt.toIso8601String(),
      'uploadedBy': uploadedBy,
      'accessLevel': accessLevel.name,
      'sharedWithDoctorIds': sharedWithDoctorIds,
      'tags': tags,
      'metadata': metadata,
    };
  }
}
