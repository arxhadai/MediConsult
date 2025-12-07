import '../../domain/entities/prescription.dart';
import '../../domain/enums/prescription_status.dart';
import 'medication_model.dart';

/// Data model for Prescription entity with JSON serialization
class PrescriptionModel extends Prescription {
  const PrescriptionModel({
    required super.id,
    required super.consultationId,
    required super.patientId,
    required super.patientName,
    super.patientAge,
    super.patientGender,
    required super.doctorId,
    required super.doctorName,
    required super.doctorSpecialization,
    required super.doctorLicenseNumber,
    super.doctorPhone,
    super.clinicName,
    super.clinicAddress,
    super.doctorSignatureUrl,
    super.diagnosis,
    required super.medications,
    super.notes,
    super.pharmacyNotes,
    required super.prescribedDate,
    super.validUntil,
    required super.status,
    super.refillsAllowed,
    super.refillsUsed = 0,
    required super.createdAt,
    super.updatedAt,
  });

  /// Create PrescriptionModel from JSON map
  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    // Parse medications from JSON
    List<MedicationModel> medications = [];
    if (json['medications'] != null) {
      medications = (json['medications'] as List)
          .map((med) => MedicationModel.fromJson(med as Map<String, dynamic>))
          .toList();
    }

    return PrescriptionModel(
      id: json['id'] as String,
      consultationId: json['consultationId'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      patientAge: json['patientAge'] as int?,
      patientGender: json['patientGender'] as String?,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      doctorSpecialization: json['doctorSpecialization'] as String,
      doctorLicenseNumber: json['doctorLicenseNumber'] as String,
      doctorPhone: json['doctorPhone'] as String?,
      clinicName: json['clinicName'] as String?,
      clinicAddress: json['clinicAddress'] as String?,
      doctorSignatureUrl: json['doctorSignatureUrl'] as String?,
      diagnosis: json['diagnosis'] as String?,
      medications: medications,
      notes: json['notes'] as String?,
      pharmacyNotes: json['pharmacyNotes'] as String?,
      prescribedDate: DateTime.parse(json['prescribedDate'] as String),
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'] as String)
          : null,
      status: PrescriptionStatus.values
          .firstWhere((element) => element.name == json['status']),
      refillsAllowed: json['refillsAllowed'] as int?,
      refillsUsed: json['refillsUsed'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert PrescriptionModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultationId': consultationId,
      'patientId': patientId,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialization': doctorSpecialization,
      'doctorLicenseNumber': doctorLicenseNumber,
      'doctorPhone': doctorPhone,
      'clinicName': clinicName,
      'clinicAddress': clinicAddress,
      'doctorSignatureUrl': doctorSignatureUrl,
      'diagnosis': diagnosis,
      'medications': medications.map((med) => (med as MedicationModel).toJson()).toList(),
      'notes': notes,
      'pharmacyNotes': pharmacyNotes,
      'prescribedDate': prescribedDate.toIso8601String(),
      'validUntil':
          validUntil?.toIso8601String(),
      'status': status.name,
      'refillsAllowed': refillsAllowed,
      'refillsUsed': refillsUsed,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt':
          updatedAt?.toIso8601String(),
    };
  }
}