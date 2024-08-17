import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:life_bookshelf/models/mypage/mypage_model.dart';
import '../userpreferences_service.dart';

class MyPageApiService {
  String baseUrl = '${dotenv.env['API']}';

  Future<MyPageUserModel> fetchUserProfile({
    String? name,
    String? bornedAt,
    String? gender,
    bool? hasChildren,
  }) async {
    String token = UserPreferences.getUserToken();
    String url = '$baseUrl/members/me';

    // PUT 요청이 필요한 경우
    if (name != null || bornedAt != null || gender != null || hasChildren != null) {
      var request = http.MultipartRequest('PUT', Uri.parse(url))
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        });

      // 전달된 인자만 추가
      if (name != null) request.fields['name'] = name;
      if (bornedAt != null) request.fields['bornedAt'] = bornedAt;
      if (gender != null) request.fields['gender'] = gender;
      if (hasChildren != null) request.fields['hasChildren'] = hasChildren.toString();

      // 요청 전송 및 응답 처리
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (responseBody.isEmpty) {
          print("회원정보 수정이 완료되었습니다. 리턴되는 값은 없습니다.");
          return MyPageUserModel.empty();
        } else {
          return MyPageUserModel.fromJson(json.decode(responseBody));
        }
      } else {
        throw Exception('Failed to update user profile ${response.statusCode}');
      }
    } else {
      // GET 요청
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print("회원정보 조회가 완료되었습니다. 리턴되는 값은 없습니다.");
          return MyPageUserModel.empty();
        } else {
          return MyPageUserModel.fromJson(json.decode(response.body));
        }
      } else {
        throw Exception('Failed to load user profile ${response.statusCode}');
      }
    }
  }



  Future<BookDetailModel> fetchBookDetails(int publicationId) async {
    // Commented out real API call for demonstration purposes
    /*
    final response = await http.get(Uri.parse('$baseUrl/v1/publications/$publicationId/progress'));
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
    // Normally handle the response or errors
  }

  // Update the switch state on the server - Test implementation
  Future<void> updateSwitchState(int index, bool state) async {
    // 실제 서버 호출은 주석 처리
    /*
    var url = Uri.parse('$baseUrl/switches/$index');
    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your_access_token',
      },
      body: json.encode({
        'state': state
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update switch state on server');
    }
    */

    // 테스트 목적의 시뮬레이션 로직
    print("Mock update: Switch at index $index set to $state");

    // 테스트 시뮬레이션 지연 시간
  }
}

