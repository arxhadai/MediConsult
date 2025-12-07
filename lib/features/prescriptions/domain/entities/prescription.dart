import 'package:equatable/equatable.dart';
import 'package:mediconsult/features/prescriptions/domain/entities/medication.dart';
import 'package:mediconsult/features/prescriptions/domain/enums/prescription_status.dart';

class Prescription extends Equatable {
  final String id;
  final String consultationId;
  final String patientId;
  final String patientName;
  final int? patientAge;
  final String? patientGender;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final String doctorLicenseNumber;
  final String? doctorPhone;
  final String? clinicName;
  final String? clinicAddress;
  final String? doctorSignatureUrl;
  final String? diagnosis;
  final List<Medication> medications;
  final String? notes;
  final String? pharmacyNotes;
  final DateTime prescribedDate;
  final DateTime? validUntil;
  final PrescriptionStatus status;
  final int? refillsAllowed;
  final int refillsUsed;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Prescription({
    required this.id,
    required this.consultationId,
    required this.patientId,
    required this.patientName,
    this.patientAge,
    this.patientGender,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorLicenseNumber,
    this.doctorPhone,
    this.clinicName,
    this.clinicAddress,
    this.doctorSignatureUrl,
    this.diagnosis,
    required this.medications,
    this.notes,
    this.pharmacyNotes,
    required this.prescribedDate,
    this.validUntil,
    required this.status,
    this.refillsAllowed,
    this.refillsUsed = 0,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isValid =>
      status == PrescriptionStatus.active &&
      (validUntil == null || DateTime.now().isBefore(validUntil!));

  bool get canRefill => refillsAllowed != null && refillsUsed < refillsAllowed!;

  int get remainingRefills =>
      refillsAllowed != null ? refillsAllowed! - refillsUsed : 0;

  bool get isExpired =>
      validUntil != null && DateTime.now().isAfter(validUntil!);

  Prescription copyWith({
    String? id,
    String? consultationId,
    String? patientId,
    String? patientName,
    int? patientAge,
    String? patientGender,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialization,
    String? doctorLicenseNumber,
    String? doctorPhone,
    String? clinicName,
    String? clinicAddress,
    String? doctorSignatureUrl,
    String? diagnosis,
    List<Medication>? medications,
    String? notes,
    String? pharmacyNotes,
    DateTime? prescribedDate,
    DateTime? validUntil,
    PrescriptionStatus? status,
    int? refillsAllowed,
    int? refillsUsed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Prescription(
      id: id ?? this.id,
      consultationId: consultationId ?? this.consultationId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      doctorLicenseNumber: doctorLicenseNumber ?? this.doctorLicenseNumber,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      doctorSignatureUrl: doctorSignatureUrl ?? this.doctorSignatureUrl,
      diagnosis: diagnosis ?? this.diagnosis,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
      pharmacyNotes: pharmacyNotes ?? this.pharmacyNotes,
      prescribedDate: prescribedDate ?? this.prescribedDate,
      validUntil: validUntil ?? this.validUntil,
      status: status ?? this.status,
      refillsAllowed: refillsAllowed ?? this.refillsAllowed,
      refillsUsed: refillsUsed ?? this.refillsUsed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, consultationId, patientId, doctorId, status];
}
