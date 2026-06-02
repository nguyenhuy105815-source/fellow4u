/// Message model - for chat with guide
library;

enum MessageSender { user, guide }

class MessageModel {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;

  const MessageModel({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final senderValue = json['sender'] ?? json['senderType'] ?? json['from'];
    return MessageModel(
      id: json['id']?.toString() ?? '',
      content: (json['content'] ?? json['message'] ?? '').toString(),
      sender: senderValue?.toString().toLowerCase() == 'guide'
          ? MessageSender.guide
          : MessageSender.user,
      timestamp: DateTime.tryParse(
            (json['timestamp'] ?? json['created_at'] ?? json['createdAt'])
                    ?.toString() ??
                '',
          ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'sender': sender == MessageSender.guide ? 'guide' : 'user',
        'timestamp': timestamp.toIso8601String(),
      };
}
