class ChatAutobiography {
  final int id;
  final int chapterId;
  final int memberId;
  final String? title;
  final String? content;
  final String? contentPreview;
  final String? coverImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatAutobiography({
    required this.id,
    required this.chapterId,
    required this.memberId,
    this.title,
    this.content,
    this.contentPreview,
    this.coverImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory ChatAutobiography.fromJson(Map<String, dynamic> json) {
    return ChatAutobiography(
      id: json['id'] as int,
      chapterId: json['chapterId'] as int,
      memberId: json['memberId'] as int,
      title: json['title'] as String?,
      content: json['content'] as String?,
      contentPreview: json['contentPreview'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'memberId': memberId,
      'title': title,
      'content': content,
      'contentPreview': contentPreview,
      'coverImageUrl': coverImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
