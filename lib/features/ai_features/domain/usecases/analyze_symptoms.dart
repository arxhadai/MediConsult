import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/symptom_analysis.dart';
import '../repositories/ai_repository.dart';

/// Use case for analyzing symptoms
@Injectable()
class AnalyzeSymptoms {
  final AiRepository repository;

  AnalyzeSymptoms(this.repository);

  /// Execute the use case to analyze symptoms
  Future<Either<Failure, SymptomAnalysis>> call(String symptoms) {
    return repository.analyzeSymptoms(symptoms);
  }
}
