import 'dart:core';

import '../../domain/entities/vital_signs.dart';

/// Data model for VitalSigns entity with JSON serialization
class VitalSignsModel extends VitalSigns {
  const VitalSignsModel({
    required super.id,
    required super.patientId,
    super.bloodPressureSystolic,
    super.bloodPressureDiastolic,
    super.heartRate,
    super.temperature,
    super.weight,
    super.height,
    super.bloodSugar,
    super.oxygenSaturation,
    super.respiratoryRate,
    required super.recordedAt,
    super.recordedBy,
    super.notes,
  });

  /// Create VitalSignsModel from JSON map
  factory VitalSignsModel.fromJson(Map<String, dynamic> json) {
    return VitalSignsModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      bloodPressureSystolic: json['bloodPressureSystolic'] as double?,
      bloodPressureDiastolic: json['bloodPressureDiastolic'] as double?,
      heartRate: json['heartRate'] as double?,
      temperature: json['temperature'] as double?,
      weight: json['weight'] as double?,
      height: json['height'] as double?,
      bloodSugar: json['bloodSugar'] as double?,
      oxygenSaturation: json['oxygenSaturation'] as double?,
      respiratoryRate: json['respiratoryRate'] as double?,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      recordedBy: json['recordedBy'] as String?,
      notes: json['notes'] as String?,
    );
  }

  /// Convert VitalSignsModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'bloodPressureSystolic': bloodPressureSystolic,
      'bloodPressureDiastolic': bloodPressureDiastolic,
      'heartRate': heartRate,
      'temperature': temperature,
      'weight': weight,
      'height': height,
      'bloodSugar': bloodSugar,
      'oxygenSaturation': oxygenSaturation,
      'respiratoryRate': respiratoryRate,
      'recordedAt': recordedAt.toIso8601String(),
      'recordedBy': recordedBy,
      'notes': notes,
    };
  }
}
