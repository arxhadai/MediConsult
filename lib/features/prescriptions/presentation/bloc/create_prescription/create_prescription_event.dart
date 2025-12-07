import 'package:equatable/equatable.dart';
import 'package:mediconsult/features/prescriptions/domain/entities/prescription.dart';
import 'package:mediconsult/features/prescriptions/domain/entities/medication.dart';

/// Base class for all create prescription events
abstract class CreatePrescriptionEvent extends Equatable {
  const CreatePrescriptionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize a new prescription
class InitializePrescription extends CreatePrescriptionEvent {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final String doctorLicenseNumber;
  final String patientId;
  final String patientName;
  final int? patientAge;
  final String? patientGender;
  final String consultationId;

  const InitializePrescription({
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorLicenseNumber,
    required this.patientId,
    required this.patientName,
    this.patientAge,
    this.patientGender,
    required this.consultationId,
  });

  @override
  List<Object?> get props => [
        doctorId,
        doctorName,
        doctorSpecialization,
        doctorLicenseNumber,
        patientId,
        patientName,
        patientAge,
        patientGender,
        consultationId,
      ];
}

/// Event to add a medication to the prescription
class AddMedication extends CreatePrescriptionEvent {
  final Medication medication;

  const AddMedication(this.medication);

  @override
  List<Object?> get props => [medication];
}

/// Event to remove a medication from the prescription
class RemoveMedication extends CreatePrescriptionEvent {
  final String medicationId;

  const RemoveMedication(this.medicationId);

  @override
  List<Object?> get props => [medicationId];
}

/// Event to update prescription details
class UpdatePrescriptionDetails extends CreatePrescriptionEvent {
  final String? diagnosis;
  final String? notes;
  final String? pharmacyNotes;
  final DateTime? validUntil;
  final int? refillsAllowed;

  const UpdatePrescriptionDetails({
    this.diagnosis,
    this.notes,
    this.pharmacyNotes,
    this.validUntil,
    this.refillsAllowed,
  });

  @override
  List<Object?> get props => [
        diagnosis,
        notes,
        pharmacyNotes,
        validUntil,
        refillsAllowed,
      ];
}

/// Event to save the prescription
class SavePrescription extends CreatePrescriptionEvent {
  final Prescription prescription;

  const SavePrescription(this.prescription);

  @override
  List<Object?> get props => [prescription];
}
