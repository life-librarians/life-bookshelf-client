class Conversation {
  final String conversationType; // 'HUMAN' 또는 'AI'
  final String content;
  final DateTime timestamp;

  Conversation({
    required this.conversationType,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // JSON 직렬화를 위한 팩토리 생성자
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationType: json['conversationType'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // JSON 직렬화를 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'conversationType': conversationType,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
