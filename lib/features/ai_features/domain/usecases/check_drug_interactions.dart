import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/drug_interaction.dart';
import '../repositories/ai_repository.dart';

/// Use case for checking drug interactions
@Injectable()
class CheckDrugInteractions {
  final AiRepository repository;

  CheckDrugInteractions(this.repository);

  /// Execute the use case to check drug interactions
  Future<Either<Failure, DrugInteraction>> call(String drugA, String drugB) {
    return repository.checkDrugInteractions(drugA, drugB);
  }
}
