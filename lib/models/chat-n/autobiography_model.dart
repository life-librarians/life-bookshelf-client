class ChatAutobiography {
  final int id;
  final String? title;
  final String? content;
  final String coverImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatAutobiography({
    required this.id,
    this.title,
    this.content,
    required this.coverImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory ChatAutobiography.fromJson(Map<String, dynamic> json) {
    return ChatAutobiography(
      id: json['autobiographyId'] as int,
      title: json['title'] as String? ?? '임시 타이틀',
      content: json['content'] as String? ?? '임시 컨텐트',
      coverImageUrl: json['coverImageUrl'] as String? ?? 'assets/images/detail-chapter-dummyImg.png',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
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
