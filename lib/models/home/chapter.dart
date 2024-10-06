class HomeChapter {
  final int chapterId;
  final String chapterNumber;
  final String chapterName;
  final String? description;
  final DateTime chapterCreatedAt;
  final List<HomeChapter> subChapters;

  HomeChapter({
    required this.chapterId,
    required this.chapterNumber,
    required this.chapterName,
    this.description,
    required this.chapterCreatedAt,
    this.subChapters = const [], // 기본값을 빈 리스트로 설정
  });

  factory HomeChapter.fromJson(Map<String, dynamic> json) {
    return HomeChapter(
      chapterId: json['chapterId'],
      chapterNumber: json['chapterNumber'],
      chapterName: json['chapterName'],
      description: json['chapterDescription'] as String?,
      chapterCreatedAt: DateTime.parse(json['chapterCreatedAt']),
      subChapters: json['subChapters'] != null
          ? (json['subChapters'] as List).map((subChapter) => HomeChapter.fromJson(subChapter)).toList()
          : [], // 'subChapters'가 null이면 빈 리스트 반환
    );
  }
}
