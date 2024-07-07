import 'dart:convert';

class MyPageUserModel {
  final String name;
  final String bornedAt;
  final String gender;
  final bool hasChildren;

  MyPageUserModel({required this.name, required this.bornedAt, required this.gender, required this.hasChildren});

  factory MyPageUserModel.fromJson(Map<String, dynamic> json) {
    return MyPageUserModel(
      name: json['name'],
      bornedAt: json['bornedAt'],
      gender: json['gender'],
      hasChildren: json['hasChildren'],
    );
  }
}

class MyPagePublicationModel {
  final int bookId;
  final String title;
  final String coverImageUrl;
  final String visibleScope;
  final int page;
  final DateTime createdAt;
  final double price;
  final String titlePosition;
  final String publishStatus;
  final DateTime requestAt;
  final DateTime willPublishedAt;

  MyPagePublicationModel({
    required this.bookId,
    required this.title,
    required this.coverImageUrl,
    required this.visibleScope,
    required this.page,
    required this.createdAt,
    required this.price,
    required this.titlePosition,
    required this.publishStatus,
    required this.requestAt,
    required this.willPublishedAt,
  });

  factory MyPagePublicationModel.fromJson(Map<String, dynamic> json) {
    return MyPagePublicationModel(
      bookId: json['bookId'],
      title: json['title'],
      coverImageUrl: json['coveImageUrl'],
      visibleScope: json['visibleScope'],
      page: json['page'],
      createdAt: DateTime.parse(json['createdAt']),
      price: json['price'],
      titlePosition: json['titlePosition'],
      publishStatus: json['publishStatus'],
      requestAt: DateTime.parse(json['requestAt']),
      willPublishedAt: DateTime.parse(json['willPublishedAt']),
    );
  }
}

class MyPagePublicationSummary {
  final int publicationId;
  final String title;

  MyPagePublicationSummary({required this.publicationId, required this.title});

  factory MyPagePublicationSummary.fromJson(Map<String, dynamic> json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Data is not a Map<String, dynamic>');
    }
    return MyPagePublicationSummary(
      publicationId: json['publicationId'] as int,
      title: json['title'] as String,
    );
  }
}

class PublicationResponse {
  final List<MyPagePublicationSummary> results;
  final bool hasNextPage;

  PublicationResponse({required this.results, required this.hasNextPage});

  factory PublicationResponse.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Expected json to be a Map<String, dynamic>');
    }

    var resultsList = json['results'] as List;
    List<MyPagePublicationSummary> results = resultsList.map((item) {
      if (item is Map<String, dynamic>) {
        return MyPagePublicationSummary.fromJson(item);
      } else {
        throw FormatException('Expected item to be a Map<String, dynamic>, got ${item.runtimeType}');
      }
    }).toList();

    return PublicationResponse(
      results: results,
      hasNextPage: json['hasNextPage'] as bool,
    );
  }

}
