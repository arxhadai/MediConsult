import 'package:equatable/equatable.dart';
import '../../../domain/entities/health_document.dart';
import '../../../domain/enums/record_category.dart';

/// Base class for all medical records states
abstract class MedicalRecordsState extends Equatable {
  const MedicalRecordsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class MedicalRecordsInitial extends MedicalRecordsState {}

/// Loading state
class MedicalRecordsLoading extends MedicalRecordsState {}

/// Loaded state with medical records
class MedicalRecordsLoaded extends MedicalRecordsState {
  final List<HealthDocument> documents;
  final RecordCategory? selectedCategory;

  const MedicalRecordsLoaded(this.documents, {this.selectedCategory});

  @override
  List<Object?> get props => [documents, selectedCategory];
}

/// Uploading state
class DocumentUploading extends MedicalRecordsState {}

/// Upload success state
class DocumentUploadSuccess extends MedicalRecordsState {}

/// Error state
class MedicalRecordsError extends MedicalRecordsState {
  final String message;

  const MedicalRecordsError(this.message);

  @override
  List<Object?> get props => [message];
}
