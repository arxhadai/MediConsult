import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription.dart';
import '../entities/medication.dart';

/// Abstract repository for prescription operations
abstract class PrescriptionRepository {
  /// Create a new prescription
  Future<Either<Failure, Prescription>> createPrescription(Prescription prescription);

  /// Get prescription by ID
  Future<Either<Failure, Prescription>> getPrescriptionById(String id);

  /// Get all prescriptions for a patient
  Future<Either<Failure, List<Prescription>>> getPatientPrescriptions(String patientId);

  /// Get all prescriptions for a consultation
  Future<Either<Failure, List<Prescription>>> getConsultationPrescriptions(String consultationId);

  /// Update an existing prescription
  Future<Either<Failure, Prescription>> updatePrescription(Prescription prescription);

  /// Delete a prescription
  Future<Either<Failure, void>> deletePrescription(String id);

  /// Generate PDF for a prescription
  Future<Either<Failure, String>> generatePrescriptionPdf(Prescription prescription);

  /// Share a prescription
  Future<Either<Failure, void>> sharePrescription(String prescriptionId, List<String> sharingMethods);

  /// Set medication reminder
  Future<Either<Failure, void>> setMedicationReminder(String prescriptionId, Medication medication);

  /// Request refill for a prescription
  Future<Either<Failure, Prescription>> requestRefill(String prescriptionId);
}