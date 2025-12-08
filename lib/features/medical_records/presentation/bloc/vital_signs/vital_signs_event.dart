import 'package:equatable/equatable.dart';
import '../../../domain/entities/vital_signs.dart';

/// Base class for all vital signs events
abstract class VitalSignsEvent extends Equatable {
  const VitalSignsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to record new vital signs
class RecordVitalSigns extends VitalSignsEvent {
  final VitalSigns vitalSigns;

  const RecordVitalSigns(this.vitalSigns);

  @override
  List<Object?> get props => [vitalSigns];
}

/// Event to load vital signs history for a patient
class LoadVitalSignsHistory extends VitalSignsEvent {
  final String patientId;

  const LoadVitalSignsHistory(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

/// Event to load latest vital signs for a patient
class LoadLatestVitalSigns extends VitalSignsEvent {
  final String patientId;

  const LoadLatestVitalSigns(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

/// Event to refresh vital signs history
class RefreshVitalSignsHistory extends VitalSignsEvent {
  final String patientId;

  const RefreshVitalSignsHistory(this.patientId);

  @override
  List<Object?> get props => [patientId];
}
