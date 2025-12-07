import '../../domain/entities/chat_message.dart';
import '../../domain/enums/message_role.dart';

/// Model for chat message that can be serialized/deserialized
class ChatMessageModel {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;

  ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  /// Convert model to entity
  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      role: role,
      content: content,
      timestamp: timestamp,
    );
  }

  /// Create model from entity
  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      role: entity.role,
      content: entity.content,
      timestamp: entity.timestamp,
    );
  }

  /// Create model from JSON
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      role: _messageRoleFromString(json['role'] as String),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': _messageRoleToString(role),
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Helper method to convert string to MessageRole
  static MessageRole _messageRoleFromString(String value) {
    switch (value) {
      case 'user':
        return MessageRole.user;
      case 'assistant':
        return MessageRole.assistant;
      case 'system':
        return MessageRole.system;
      default:
        return MessageRole.user;
    }
  }

  /// Helper method to convert MessageRole to string
  static String _messageRoleToString(MessageRole role) {
    switch (role) {
      case MessageRole.user:
        return 'user';
      case MessageRole.assistant:
        return 'assistant';
      case MessageRole.system:
        return 'system';
    }
  }
}