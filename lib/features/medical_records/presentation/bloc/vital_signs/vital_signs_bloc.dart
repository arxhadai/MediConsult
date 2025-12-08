import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/record_vital_signs.dart' as usecases;
import '../../../domain/usecases/get_vital_signs_history.dart' as usecases;
import '../../../domain/usecases/get_latest_vital_signs.dart' as usecases;
import 'vital_signs_event.dart';
import 'vital_signs_state.dart';

/// BLoC for managing vital signs state
@Injectable()
class VitalSignsBloc extends Bloc<VitalSignsEvent, VitalSignsState> {
  final usecases.RecordVitalSigns _recordVitalSigns;
  final usecases.GetVitalSignsHistory _getVitalSignsHistory;
  final usecases.GetLatestVitalSigns _getLatestVitalSigns;

  VitalSignsBloc({
    required usecases.RecordVitalSigns recordVitalSigns,
    required usecases.GetVitalSignsHistory getVitalSignsHistory,
    required usecases.GetLatestVitalSigns getLatestVitalSigns,
  })  : _recordVitalSigns = recordVitalSigns,
        _getVitalSignsHistory = getVitalSignsHistory,
        _getLatestVitalSigns = getLatestVitalSigns,
        super(VitalSignsInitial()) {
    on<RecordVitalSigns>(_onRecordVitalSigns);
    on<LoadVitalSignsHistory>(_onLoadVitalSignsHistory);
    on<LoadLatestVitalSigns>(_onLoadLatestVitalSigns);
    on<RefreshVitalSignsHistory>(_onRefreshVitalSignsHistory);
  }

  /// Handle recording vital signs
  Future<void> _onRecordVitalSigns(
    RecordVitalSigns event,
    Emitter<VitalSignsState> emit,
  ) async {
    emit(VitalSignsRecording());
    final result = await _recordVitalSigns(event.vitalSigns);

    result.fold(
      (failure) => emit(VitalSignsError(failure.toString())),
      (_) => emit(VitalSignsRecorded()),
    );
  }

  /// Handle loading vital signs history
  Future<void> _onLoadVitalSignsHistory(
    LoadVitalSignsHistory event,
    Emitter<VitalSignsState> emit,
  ) async {
    emit(VitalSignsLoading());
    final result = await _getVitalSignsHistory(event.patientId);

    result.fold(
      (failure) => emit(VitalSignsError(failure.toString())),
      (vitalSignsHistory) => emit(VitalSignsHistoryLoaded(vitalSignsHistory)),
    );
  }

  /// Handle loading latest vital signs
  Future<void> _onLoadLatestVitalSigns(
    LoadLatestVitalSigns event,
    Emitter<VitalSignsState> emit,
  ) async {
    emit(VitalSignsLoading());
    final result = await _getLatestVitalSigns(event.patientId);

    result.fold(
      (failure) => emit(VitalSignsError(failure.toString())),
      (latestVitalSigns) => emit(LatestVitalSignsLoaded(latestVitalSigns)),
    );
  }

  /// Handle refreshing vital signs history
  Future<void> _onRefreshVitalSignsHistory(
    RefreshVitalSignsHistory event,
    Emitter<VitalSignsState> emit,
  ) async {
    emit(VitalSignsLoading());
    final result = await _getVitalSignsHistory(event.patientId);

    result.fold(
      (failure) => emit(VitalSignsError(failure.toString())),
      (vitalSignsHistory) => emit(VitalSignsHistoryLoaded(vitalSignsHistory)),
    );
  }
}
