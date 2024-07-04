class HomeChapter {
  final int chapterId;
  final int chapterNumber;
  final String chapterName;
  final DateTime chapterCreatedAt;
  final int? currentChapterId;

  HomeChapter(
      {required this.chapterId,
      required this.chapterNumber,
      required this.chapterName,
      required this.chapterCreatedAt,
      this.currentChapterId});

  factory HomeChapter.fromJson(Map<String, dynamic> json) {
    return HomeChapter(
      chapterId: json['chapterId'],
      chapterNumber: json['chapterNumber'],
      chapterName: json['chapterName'],
      chapterCreatedAt: DateTime.parse(json['chapterCreatedAt']),
      currentChapterId: json.containsKey('currentChapterId')
          ? json['currentChapterId']
          : null,
    );
  }
}
