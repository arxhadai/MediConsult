import 'package:equatable/equatable.dart';
import '../../domain/entities/prescription.dart';

/// Base class for all prescription list events
abstract class PrescriptionListEvent extends Equatable {
  const PrescriptionListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load prescriptions for a patient
class LoadPrescriptions extends PrescriptionListEvent {
  final String patientId;

  const LoadPrescriptions(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

/// Event to refresh prescriptions
class RefreshPrescriptions extends PrescriptionListEvent {
  final String patientId;

  const RefreshPrescriptions(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

/// Event to delete a prescription
class DeletePrescriptionEvent extends PrescriptionListEvent {
  final String prescriptionId;

  const DeletePrescriptionEvent(this.prescriptionId);

  @override
  List<Object?> get props => [prescriptionId];
}