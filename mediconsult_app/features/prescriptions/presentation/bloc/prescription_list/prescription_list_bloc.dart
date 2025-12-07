import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_patient_prescriptions.dart';
import '../../../domain/usecases/delete_prescription.dart';
import '../../../domain/entities/prescription.dart';
import 'prescription_list_event.dart';
import 'prescription_list_state.dart';

/// BLoC for managing prescription list state
class PrescriptionListBloc
    extends Bloc<PrescriptionListEvent, PrescriptionListState> {
  final GetPatientPrescriptions _getPatientPrescriptions;
  final DeletePrescription _deletePrescription;

  PrescriptionListBloc({
    required GetPatientPrescriptions getPatientPrescriptions,
    required DeletePrescription deletePrescription,
  })  : _getPatientPrescriptions = getPatientPrescriptions,
        _deletePrescription = deletePrescription,
        super(PrescriptionListInitial()) {
    on<LoadPrescriptions>(_onLoadPrescriptions);
    on<RefreshPrescriptions>(_onRefreshPrescriptions);
    on<DeletePrescriptionEvent>(_onDeletePrescription);
  }

  /// Handle loading prescriptions
  Future<void> _onLoadPrescriptions(
    LoadPrescriptions event,
    Emitter<PrescriptionListState> emit,
  ) async {
    emit(PrescriptionListLoading());
    final result = await _getPatientPrescriptions(
      GetPatientPrescriptionsParams(patientId: event.patientId),
    );

    result.fold(
      (failure) => emit(PrescriptionListError(failure.toString())),
      (prescriptions) => emit(PrescriptionListLoaded(prescriptions)),
    );
  }

  /// Handle refreshing prescriptions
  Future<void> _onRefreshPrescriptions(
    RefreshPrescriptions event,
    Emitter<PrescriptionListState> emit,
  ) async {
    emit(PrescriptionListLoading());
    final result = await _getPatientPrescriptions(
      GetPatientPrescriptionsParams(patientId: event.patientId),
    );

    result.fold(
      (failure) => emit(PrescriptionListError(failure.toString())),
      (prescriptions) => emit(PrescriptionListLoaded(prescriptions)),
    );
  }

  /// Handle deleting a prescription
  Future<void> _onDeletePrescription(
    DeletePrescriptionEvent event,
    Emitter<PrescriptionListState> emit,
  ) async {
    // Get current state
    if (state is PrescriptionListLoaded) {
      final currentState = state as PrescriptionListLoaded;
      
      // Delete prescription
      final result = await _deletePrescription(
        DeletePrescriptionParams(id: event.prescriptionId),
      );

      result.fold(
        (failure) => emit(PrescriptionListError(failure.toString())),
        (_) {
          // Remove deleted prescription from list
          final updatedPrescriptions = List<dynamic>.from(currentState.prescriptions)
            ..removeWhere((prescription) => prescription.id == event.prescriptionId);
          emit(PrescriptionListLoaded(updatedPrescriptions));
        },
      );
    }
  }
}