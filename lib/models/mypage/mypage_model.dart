import 'dart:convert';

class MyPageUserModel {
  final String name;
  final String bornedAt;
  final String gender;
  final bool hasChildren;

  MyPageUserModel({required this.name, required this.bornedAt, required this.gender, required this.hasChildren});

  // 빈 모델을 반환하는 factory 생성자
  factory MyPageUserModel.empty() {
    return MyPageUserModel(
      name: '',
      bornedAt: '',
      gender: '',
      hasChildren: false,
    );
  }

  factory MyPageUserModel.fromJson(Map<String, dynamic> json) {
    return MyPageUserModel(
        name: json['name'],
        bornedAt: json['bornedAt'],
        gender: json['gender'],
        hasChildren: json['hasChildren']
    );
  }
}

class BookDetailModel {
  final int bookId;
  final int publicationId;  // 추가
  final String? title;
  final String? coverImageUrl;
  final String? visibleScope;
  final int? page;
  final String? createdAt;
  final int? price;
  final String? titlePosition;
  final String? publishStatus;
  final String? requestAt;
  final String? willPublishedAt;

  BookDetailModel({
    required this.bookId,
    required this.publicationId,  // 추가
    required this.title,
    required this.coverImageUrl,
    required this.visibleScope,
    this.page,
    required this.createdAt,
    this.price,
    required this.titlePosition,
    required this.publishStatus,
    required this.requestAt,
    required this.willPublishedAt,
  });

  factory BookDetailModel.fromJson(Map<String, dynamic> json) {
    return BookDetailModel(
      bookId: json['bookId'],
      publicationId: json['publicationId'],  // 추가
      title: utf8.decode(json['title'].toString().codeUnits),
      coverImageUrl: json['coverImageUrl'] as String?,
      visibleScope: json['visibleScope'] as String?,
      page: json['page'] as int?,
      createdAt: json['createdAt'],
      price: json['price'] as int?,
      titlePosition: json['titlePosition'] as String?,
      publishStatus: json['publishStatus'] as String?,
      requestAt: json['requestAt'] as String?,
      willPublishedAt: json['willPublishedAt'] as String?,
    );
  }
}


class BookListModel {
  final List<BookDetailModel> results;
  final int currentPage;
  final int totalElements;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  BookListModel({
    required this.results,
    this.currentPage = 1,
    this.totalElements = 0,
    this.totalPages = 1,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory BookListModel.fromJson(Map<String, dynamic> json) {
    return BookListModel(
      results: List<BookDetailModel>.from(json['results'].map((x) => BookDetailModel.fromJson(x))),
      currentPage: json['currentPage'] ?? 1,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,

    );
  }
}



class NotificationModel {
  final int notificationId;
  final String noticeType;
  final String description;
  final DateTime? subscribedAt;

  NotificationModel({
    required this.notificationId,
    required this.noticeType,
    required this.description,
    this.subscribedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'],
      noticeType: json['noticeType'],
      description: json['description'],
      subscribedAt: json['subscribedAt'] != null ? DateTime.parse(json['subscribedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'noticeType': noticeType,
      'description': description,
      'subscribedAt': subscribedAt?.toIso8601String(),
    };
  }
}

