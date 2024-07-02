class Chapter {
  final int chapterId;
  final int chapterNumber;
  final String chapterName;
  final DateTime chapterCreatedAt;
  final int? currentChapterId;

  Chapter({required this.chapterId, required this.chapterNumber, required this.chapterName, required this.chapterCreatedAt, this.currentChapterId});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterId: json['chapterId'],
      chapterNumber: json['chapterNumber'],
      chapterName: json['chapterName'],
      chapterCreatedAt: DateTime.parse(json['chapterCreatedAt']),
      currentChapterId: json.containsKey('currentChapterId') ? json['currentChapterId'] : null,
    );
  }
}

