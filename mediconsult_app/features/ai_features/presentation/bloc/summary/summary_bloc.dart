import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/utils/logger.dart';
import '../../../domain/entities/consultation_summary.dart';
import '../../../domain/usecases/generate_summary.dart';

part 'summary_event.dart';
part 'summary_state.dart';

/// BLoC for summary feature
@injectable
class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  static final logger = AppLogger;
  final GenerateSummary _generateSummary;

  SummaryBloc(this._generateSummary) : super(SummaryInitial()) {
    on<SummaryGenerationRequested>(_onSummaryGenerationRequested);
  }

  Future<void> _onSummaryGenerationRequested(
    SummaryGenerationRequested event,
    Emitter<SummaryState> emit,
  ) async {
    emit(SummaryLoading());
    
    try {
      final result = await _generateSummary(event.consultationTranscript);
      
      result.fold(
        (failure) {
          emit(SummaryError(
            message: failure.toString(),
          ));
        },
        (summary) {
          emit(SummarySuccess(summary: summary));
        },
      );
    } catch (e) {
      AppLogger.error('Error generating summary: $e');
      emit(SummaryError(message: 'Failed to generate summary'));
    }
  }
}