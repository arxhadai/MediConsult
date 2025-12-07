import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transcription_repository.dart';

/// Use case for starting transcription
@Injectable()
class StartTranscription {
  final TranscriptionRepository repository;

  StartTranscription(this.repository);

  /// Execute the use case to start transcription
  Future<Either<Failure, void>> call() {
    return repository.startTranscription();
  }
}
