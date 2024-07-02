class HomeAutobiography {
  final int autobiographyId;
  final String title;
  final String contentPreview;
  final String coverImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  HomeAutobiography({required this.autobiographyId, required this.title, required this.contentPreview, required this.coverImageUrl, required this.createdAt, required this.updatedAt});

  factory HomeAutobiography.fromJson(Map<String, dynamic> json) {
    return HomeAutobiography(
      autobiographyId: json['autobiographyId'],
      title: json['title'],
      contentPreview: json['contentPreview'],
      coverImageUrl: json['coverImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
