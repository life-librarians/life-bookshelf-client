class Conversation {
  final int conversationId;
  final String content;
  final String conversationType;
  final DateTime createdAt;

  Conversation({
    required this.conversationId,
    required this.content,
    required this.conversationType,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversationId'],
      content: json['content'],
      conversationType: json['conversationType'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
