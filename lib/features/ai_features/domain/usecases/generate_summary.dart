import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/consultation_summary.dart';
import '../repositories/ai_repository.dart';

/// Use case for generating consultation summary
@Injectable()
class GenerateSummary {
  final AiRepository repository;

  GenerateSummary(this.repository);

  /// Execute the use case to generate consultation summary
  Future<Either<Failure, ConsultationSummary>> call(
      String consultationTranscript) {
    return repository.generateSummary(consultationTranscript);
  }
}
