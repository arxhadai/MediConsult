import 'package:equatable/equatable.dart';
import '../../../domain/entities/vital_signs.dart';

/// Base class for all vital signs states
abstract class VitalSignsState extends Equatable {
  const VitalSignsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class VitalSignsInitial extends VitalSignsState {}

/// Loading state
class VitalSignsLoading extends VitalSignsState {}

/// Loaded state with vital signs history
class VitalSignsHistoryLoaded extends VitalSignsState {
  final List<VitalSigns> vitalSignsHistory;

  const VitalSignsHistoryLoaded(this.vitalSignsHistory);

  @override
  List<Object?> get props => [vitalSignsHistory];
}

/// Loaded state with latest vital signs
class LatestVitalSignsLoaded extends VitalSignsState {
  final VitalSigns latestVitalSigns;

  const LatestVitalSignsLoaded(this.latestVitalSigns);

  @override
  List<Object?> get props => [latestVitalSigns];
}

/// Recording state
class VitalSignsRecording extends VitalSignsState {}

/// Recording success state
class VitalSignsRecorded extends VitalSignsState {}

/// Error state
class VitalSignsError extends VitalSignsState {
  final String message;

  const VitalSignsError(this.message);

  @override
  List<Object?> get props => [message];
}
