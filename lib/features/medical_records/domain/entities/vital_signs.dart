import 'package:equatable/equatable.dart';

class VitalSigns extends Equatable {
  final String id;
  final String patientId;
  final double? bloodPressureSystolic;
  final double? bloodPressureDiastolic;
  final double? heartRate;
  final double? temperature;
  final double? weight;
  final double? height;
  final double? bloodSugar;
  final double? oxygenSaturation;
  final double? respiratoryRate;
  final DateTime recordedAt;
  final String? recordedBy;
  final String? notes;

  const VitalSigns({
    required this.id,
    required this.patientId,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.heartRate,
    this.temperature,
    this.weight,
    this.height,
    this.bloodSugar,
    this.oxygenSaturation,
    this.respiratoryRate,
    required this.recordedAt,
    this.recordedBy,
    this.notes,
  });

  double? get bmi {
    if (weight != null && height != null && height! > 0) {
      final heightInMeters = height! / 100;
      return weight! / (heightInMeters * heightInMeters);
    }
    return null;
  }

  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  String? get bloodPressureFormatted {
    if (bloodPressureSystolic != null && bloodPressureDiastolic != null) {
      return '${bloodPressureSystolic!.toInt()}/${bloodPressureDiastolic!.toInt()} mmHg';
    }
    return null;
  }

  String? get bloodPressureCategory {
    if (bloodPressureSystolic == null || bloodPressureDiastolic == null) {
      return null;
    }
    if (bloodPressureSystolic! < 120 && bloodPressureDiastolic! < 80) {
      return 'Normal';
    }
    if (bloodPressureSystolic! < 130 && bloodPressureDiastolic! < 80) {
      return 'Elevated';
    }
    if (bloodPressureSystolic! < 140 || bloodPressureDiastolic! < 90) {
      return 'High (Stage 1)';
    }
    return 'High (Stage 2)';
  }

  VitalSigns copyWith({
    String? id,
    String? patientId,
    double? bloodPressureSystolic,
    double? bloodPressureDiastolic,
    double? heartRate,
    double? temperature,
    double? weight,
    double? height,
    double? bloodSugar,
    double? oxygenSaturation,
    double? respiratoryRate,
    DateTime? recordedAt,
    String? recordedBy,
    String? notes,
  }) {
    return VitalSigns(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      bloodPressureSystolic:
          bloodPressureSystolic ?? this.bloodPressureSystolic,
      bloodPressureDiastolic:
          bloodPressureDiastolic ?? this.bloodPressureDiastolic,
      heartRate: heartRate ?? this.heartRate,
      temperature: temperature ?? this.temperature,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      oxygenSaturation: oxygenSaturation ?? this.oxygenSaturation,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
      recordedAt: recordedAt ?? this.recordedAt,
      recordedBy: recordedBy ?? this.recordedBy,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        bloodPressureSystolic,
        bloodPressureDiastolic,
        heartRate,
        temperature,
        weight,
        height,
        bloodSugar,
        oxygenSaturation,
        respiratoryRate,
        recordedAt,
      ];
}
