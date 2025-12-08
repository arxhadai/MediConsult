import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/get_all_documents.dart' as usecases;
import '../../../domain/usecases/get_documents_by_category.dart' as usecases;
import '../../../domain/usecases/upload_document.dart' as usecases;
import '../../../domain/usecases/delete_document.dart' as usecases;
import '../../../domain/usecases/share_document_with_doctor.dart' as usecases;
import '../../../domain/usecases/revoke_document_access.dart' as usecases;
import '../../../domain/entities/health_document.dart';
import 'medical_records_event.dart';
import 'medical_records_state.dart';

/// BLoC for managing medical records state
@Injectable()
class MedicalRecordsBloc
    extends Bloc<MedicalRecordsEvent, MedicalRecordsState> {
  final usecases.GetAllDocuments _getAllDocuments;
  final usecases.GetDocumentsByCategory _getDocumentsByCategory;
  final usecases.UploadDocument _uploadDocument;
  final usecases.DeleteDocument _deleteDocument;
  final usecases.ShareDocumentWithDoctor _shareDocumentWithDoctor;
  final usecases.RevokeDocumentAccess _revokeDocumentAccess;

  MedicalRecordsBloc({
    required usecases.GetAllDocuments getAllDocuments,
    required usecases.GetDocumentsByCategory getDocumentsByCategory,
    required usecases.UploadDocument uploadDocument,
    required usecases.DeleteDocument deleteDocument,
    required usecases.ShareDocumentWithDoctor shareDocumentWithDoctor,
    required usecases.RevokeDocumentAccess revokeDocumentAccess,
  })  : _getAllDocuments = getAllDocuments,
        _getDocumentsByCategory = getDocumentsByCategory,
        _uploadDocument = uploadDocument,
        _deleteDocument = deleteDocument,
        _shareDocumentWithDoctor = shareDocumentWithDoctor,
        _revokeDocumentAccess = revokeDocumentAccess,
        super(MedicalRecordsInitial()) {
    on<LoadMedicalRecords>((event, emit) => _onLoadMedicalRecords(event, emit));
    on<LoadMedicalRecordsByCategory>(
        (event, emit) => _onLoadMedicalRecordsByCategory(event, emit));
    on<UploadDocument>((event, emit) => _onUploadDocument(event, emit));
    on<DeleteDocument>((event, emit) => _onDeleteDocument(event, emit));
    on<ShareDocumentWithDoctor>(
        (event, emit) => _onShareDocumentWithDoctor(event, emit));
    on<RevokeDocumentAccess>(
        (event, emit) => _onRevokeDocumentAccess(event, emit));
    on<RefreshMedicalRecords>(
        (event, emit) => _onRefreshMedicalRecords(event, emit));
  }

  /// Handle loading all medical records for a patient
  Future<void> _onLoadMedicalRecords(
    LoadMedicalRecords event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(MedicalRecordsLoading());
    final result = await _getAllDocuments(event.patientId);

    result.fold(
      (failure) => emit(MedicalRecordsError(failure.toString())),
      (documents) => emit(MedicalRecordsLoaded(documents)),
    );
  }

  /// Handle loading medical records by category
  Future<void> _onLoadMedicalRecordsByCategory(
    LoadMedicalRecordsByCategory event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(MedicalRecordsLoading());
    final result =
        await _getDocumentsByCategory(event.patientId, event.category);

    result.fold(
      (failure) => emit(MedicalRecordsError(failure.toString())),
      (documents) => emit(
          MedicalRecordsLoaded(documents, selectedCategory: event.category)),
    );
  }

  /// Handle uploading a document
  Future<void> _onUploadDocument(
    UploadDocument event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(DocumentUploading());
    final result = await _uploadDocument(event.document);

    result.fold(
      (failure) => emit(MedicalRecordsError(failure.toString())),
      (_) => emit(DocumentUploadSuccess()),
    );
  }

  /// Handle deleting a document
  Future<void> _onDeleteDocument(
    DeleteDocument event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    // Get current state
    if (state is MedicalRecordsLoaded) {
      final currentState = state as MedicalRecordsLoaded;

      // Delete document
      final result = await _deleteDocument(event.documentId);

      result.fold(
        (failure) => emit(MedicalRecordsError(failure.toString())),
        (_) {
          // Remove deleted document from list
          final updatedDocuments =
              List<HealthDocument>.from(currentState.documents)
                ..removeWhere((document) => document.id == event.documentId);
          emit(MedicalRecordsLoaded(updatedDocuments,
              selectedCategory: currentState.selectedCategory));
        },
      );
    }
  }

  /// Handle sharing a document with a doctor
  Future<void> _onShareDocumentWithDoctor(
    ShareDocumentWithDoctor event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    final result =
        await _shareDocumentWithDoctor(event.documentId, event.doctorId);

    result.fold(
      (failure) => emit(MedicalRecordsError(failure.toString())),
      (_) {
        // Emit success state or refresh the list
        if (state is MedicalRecordsLoaded) {
          emit(state); // Re-emit current state to trigger UI update
        }
      },
    );
  }

  /// Handle revoking document access from a doctor
  Future<void> _onRevokeDocumentAccess(
    RevokeDocumentAccess event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    final result =
        await _revokeDocumentAccess(event.documentId, event.doctorId);

    result.fold(
      (failure) => emit(MedicalRecordsError(failure.toString())),
      (_) {
        // Emit success state or refresh the list
        if (state is MedicalRecordsLoaded) {
          emit(state); // Re-emit current state to trigger UI update
        }
      },
    );
  }

  /// Handle refreshing medical records
  Future<void> _onRefreshMedicalRecords(
    RefreshMedicalRecords event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(MedicalRecordsLoading());
    final result = await _getAllDocuments(event.patientId);

    result.fold(
      (failure) => emit(MedicalRecordsError(failure.toString())),
      (documents) => emit(MedicalRecordsLoaded(documents)),
    );
  }
}
