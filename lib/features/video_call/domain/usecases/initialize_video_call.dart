import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_call_repository.dart';

/// Parameters for initializing video call
class InitializeParams extends Equatable {
  final String appId;

  const InitializeParams({required this.appId});

  @override
  List<Object?> get props => [appId];
}

/// Use case for initializing the video call service
@Injectable()
class InitializeVideoCall {
  final VideoCallRepository repository;

  InitializeVideoCall(this.repository);

  Future<Either<Failure, void>> call(InitializeParams params) async {
    return await repository.initialize(appId: params.appId);
  }
}
