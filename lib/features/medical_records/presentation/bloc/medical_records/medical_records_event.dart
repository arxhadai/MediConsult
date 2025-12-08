import 'package:equatable/equatable.dart';
import '../../../domain/entities/health_document.dart';
import '../../../domain/enums/record_category.dart';

/// Base class for all medical records events
abstract class MedicalRecordsEvent extends Equatable {
  const MedicalRecordsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all medical records for a patient
class LoadMedicalRecords extends MedicalRecordsEvent {
  final String patientId;

  const LoadMedicalRecords(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

/// Event to load medical records by category
class LoadMedicalRecordsByCategory extends MedicalRecordsEvent {
  final String patientId;
  final RecordCategory category;

  const LoadMedicalRecordsByCategory(this.patientId, this.category);

  @override
  List<Object?> get props => [patientId, category];
}

/// Event to upload a new document
class UploadDocument extends MedicalRecordsEvent {
  final HealthDocument document;

  const UploadDocument(this.document);

  @override
  List<Object?> get props => [document];
}

/// Event to delete a document
class DeleteDocument extends MedicalRecordsEvent {
  final String documentId;

  const DeleteDocument(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// Event to share a document with a doctor
class ShareDocumentWithDoctor extends MedicalRecordsEvent {
  final String documentId;
  final String doctorId;

  const ShareDocumentWithDoctor(this.documentId, this.doctorId);

  @override
  List<Object?> get props => [documentId, doctorId];
}

/// Event to revoke document access from a doctor
class RevokeDocumentAccess extends MedicalRecordsEvent {
  final String documentId;
  final String doctorId;

  const RevokeDocumentAccess(this.documentId, this.doctorId);

  @override
  List<Object?> get props => [documentId, doctorId];
}

/// Event to refresh medical records
class RefreshMedicalRecords extends MedicalRecordsEvent {
  final String patientId;

  const RefreshMedicalRecords(this.patientId);

  @override
  List<Object?> get props => [patientId];
}
