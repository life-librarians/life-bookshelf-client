import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:life_bookshelf/models/mypage/mypage_model.dart';// Assume this is the model for the list of books with pagination

class MyPageApiService {
  final String baseUrl = "https://yourapi.com/api/v1";

  Future<MyPageUserModel> fetchUserProfile() async {
    // Commented out real API call for demonstration purposes
    /*
    final response = await http.get(Uri.parse('$baseUrl/members/me'));
    if (response.statusCode == 200) {
      return MyPageUserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
    */
    // Mock response for testing
    var responseJson = json.encode({
      "name": "김남철",
      "bornedAt": "2005-02-24",
      "gender": "male",
      "hasChildren": false
    });
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    return MyPageUserModel.fromJson(json.decode(responseJson));
  }

  Future<BookDetailModel> fetchBookDetails(int memberId) async {
    // Commented out real API call for demonstration purposes
    /*
    final response = await http.get(Uri.parse('$baseUrl/books/$memberId'));
    if (response.statusCode == 200) {
      return BookDetailModel.fromJson(json.decode(response.body));
    } else {
      Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception('${errorResponse['code']}: ${errorResponse['message']}');
    }
    */
    // Mock response for testing
    var responseJson = json.encode({
      "bookId": 2,
      "title": "나의 두번째 출판 책",
      "coverImageUrl": "https://my_second_book",
      "visibleScope": "PRIVATE",
      "page": 104,
      "createdAt": "2023-01-02T00:00:00Z",
      "price": 100000,
      "titlePosition": "TOP",
      "publishStatus": "REQUESTED",
      "requestAt": "2023-01-03T00:00:00Z",
      "willPublishedAt": "2023-01-16T00:00:00Z"
    });
    await Future.delayed(Duration(seconds: 1));  // Simulating network delay
    return BookDetailModel.fromJson(json.decode(responseJson));
  }

  Future<BookListModel> fetchPublishedBooks(int page, int size) async {
    // Commented out real API call for demonstration purposes
    /*
    final response = await http.get(Uri.parse('$baseUrl/books?page=$page&size=$size'));
    if (response.statusCode == 200) {
      return BookListModel.fromJson(json.decode(response.body));
    } else {
      Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception('${errorResponse['code']}: ${errorResponse['message']}');
    }
    */
    // Mock response for testing
    print("Fetching published books for page $page with size $size");
    var responseJson = json.encode({
      "results": [
        {
          "bookId": 1,
          "publicationId": 1,
          "title": "나의 첫 출판 책",
          "contentPreview": "This is the story of my early life...",
          "coverImageUrl": "https://my_first_book",
          "visibleScope": "PUBLIC",
          "page": 142,
          "createdAt": "2023-01-01T00:00:00Z"
        },
        {
          "bookId": 2,
          "publicationId": 2,
          "title": "나의 두번째 출판 책",
          "contentPreview": "Continuing my journey...",
          "coverImageUrl": "https://my_second_book",
          "visibleScope": "PRIVATE",
          "page": 104,
          "createdAt": "2023-01-02T00:00:00Z"
        }
      ],
      "currentPage": 1,
      "totalElements": 3,
      "totalPages": 1,
      "hasNextPage": false,
      "hasPreviousPage": false
    });

    await Future.delayed(Duration(seconds: 1));  // Simulating network delay
    return BookListModel.fromJson(json.decode(responseJson));
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    /*
    final response = await http.get(Uri.parse('$baseUrl/notifications/subscriptions'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['results'];
      return data.map((item) => NotificationModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
    */
    // Mock response for testing
    var responseJson = json.encode({
      "results": [
        {
          "notificationId": 1,
          "noticeType": "ANNOUNCEMENT",
          "description": "시스템에서 제공하는 공지 알림",
          "subscribedAt": "2023-01-01T00:00:00Z"
        },
        {
          "notificationId": 2,
          "noticeType": "INTERVIEW_REMIND",
          "description": "자서전 인터뷰 리마인드 알림",
          "subscribedAt": "2023-01-01T00:00:00Z"
        }
      ]
    });
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    List<dynamic> data = json.decode(responseJson)['results'];
    return data.map((item) => NotificationModel.fromJson(item)).toList();
  }

  Future<void> updateNotificationSubscriptions(List<int> notificationIds) async {
    /*
    final response = await http.post(
      Uri.parse('$baseUrl/notifications/subscriptions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'notificationIds': notificationIds}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update subscriptions');
    }
    */
    // Mock response for testing
    print("Updating subscription for notification IDs: $notificationIds");
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    // Normally handle the response or errors
  }
}

