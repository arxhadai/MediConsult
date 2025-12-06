import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_message.dart';
import '../repositories/ai_repository.dart';

/// Use case for sending a chat message
class SendChatMessage {
  final AiRepository repository;

  SendChatMessage(this.repository);

  /// Execute the use case to send a chat message
  Future<Either<Failure, ChatMessage>> call(ChatMessage message) {
    return repository.sendChatMessage(message);
  }
}