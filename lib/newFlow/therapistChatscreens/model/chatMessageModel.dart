enum MessageRole {
  user,
  assistant,
}

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    required this.content,
    required this.role,
    this.id = '',
    DateTime? timestamp,
    this.isLoading = false,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': role == MessageRole.user ? 'user' : 'assistant',
      'timestamp': timestamp,
      'isLoading': isLoading,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      role: json['role'] == 'user' ? MessageRole.user : MessageRole.assistant,
      timestamp: json['timestamp'] ?? DateTime.now(),
      isLoading: json['isLoading'] ?? false,
    );
  }
}