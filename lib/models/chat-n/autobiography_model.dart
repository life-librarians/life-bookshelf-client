class ChatAutobiography {
  final int id;
  final String title;
  final String content;
  final String coverImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatAutobiography({
    required this.id,
    required this.title,
    required this.content,
    required this.coverImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory ChatAutobiography.fromJson(Map<String, dynamic> json) {
    return ChatAutobiography(
      id: json['autobiographyId'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'autobiographyId': id,
      'title': title,
      'content': content,
      'coverImageUrl': coverImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
