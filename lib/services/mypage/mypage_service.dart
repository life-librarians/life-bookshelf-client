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
      var decodedResponseBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        if (decodedResponseBody.isEmpty) {
          print("회원정보 조회가 완료되었습니다. 리턴되는 값은 없습니다.");
          return MyPageUserModel.empty();
        } else {
          return MyPageUserModel.fromJson(json.decode(decodedResponseBody));
        }
      } else {
        throw Exception('Failed to load user profile ${response.statusCode}');
      }
    }
  }

  Future<BookDetailModel> fetchBookDetails(int publicationId) async {
    print('Fetching book details for publication ID: $publicationId');
    final token = UserPreferences.getUserToken();
    final url = '$baseUrl/publications/$publicationId/progress';

    print('Requesting URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': '*/*',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');

    // 디버그 출력할 때도 UTF-8 디코딩 적용
    print('Response body: ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      return BookDetailModel.fromJson(json.decode(decodedBody));
    } else {
      var decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> errorResponse = json.decode(decodedBody);
      throw Exception('${errorResponse['code']}: ${errorResponse['message']}');
    }
  }

  Future<BookListModel> fetchPublishedBooks(int page, int size) async {
    // Commented out real API call for demonstration purposes
    final String url = '$baseUrl/publications/me?page=$page&size=$size';
    String token = UserPreferences.getUserToken();
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return BookListModel.fromJson(json.decode(response.body));
    } else {
      Map<String, dynamic> errorResponse = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('${errorResponse['code']}: ${errorResponse['message']}');
    }

    // Mock response for testing
    // print("Fetching published books for page $page with size $size");
    // var responseJson = json.encode({
    //   "results": [
    //     {
    //       "bookId": 1,
    //       "publicationId": 1,
    //       "title": "나의 첫 출판 책",
    //       "contentPreview": "This is the story of my early life...",
    //       "coverImageUrl": "https://my_first_book",
    //       "visibleScope": "PUBLIC",
    //       "page": 142,
    //       "createdAt": "2023-01-01T00:00:00Z"
    //     },
    //     {
    //       "bookId": 2,
    //       "publicationId": 2,
    //       "title": "나의 두번째 출판 책",
    //       "contentPreview": "Continuing my journey...",
    //       "coverImageUrl": "https://my_second_book",
    //       "visibleScope": "PRIVATE",
    //       "page": 104,
    //       "createdAt": "2023-01-02T00:00:00Z"
    //     }
    //   ],
    //   "currentPage": 1,
    //   "totalElements": 3,
    //   "totalPages": 1,
    //   "hasNextPage": false,
    //   "hasPreviousPage": false
    // });
    // return BookListModel.fromJson(json.decode(responseJson));
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

  Future<void> deleteUser() async {
    String token = UserPreferences.getUserToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/auth/unregister'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      print("회원탈퇴 성공");
    } else {
      var decodedBody = utf8.decode(response.bodyBytes);
      print("회원탈퇴 실패: ${response.statusCode} - $decodedBody");
      throw Exception('회원탈퇴 실패: ${response.statusCode} - $decodedBody');
    }
  }
}

