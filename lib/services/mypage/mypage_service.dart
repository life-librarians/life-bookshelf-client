import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:life_bookshelf/models/mypage/mypage_model.dart';


class MyPageApiService {
  // Base URL for the actual API
  final String baseUrl = "https://yourapi.com/api/v1";

  Future<MyPageUserModel> fetchUserProfile() async {
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
  Future<PublicationResponse> fetchMyPublications(int page, int size) async {
    // Uncomment the following lines to use actual API call
    /*
    final response = await http.get(Uri.parse('$baseUrl/publications/me?page=$page&size=$size'));
    if (response.statusCode == 200) {
      return PublicationResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load publications list');
    }
    */

    var responseJson = json.encode({
      "results": [
        {
          "bookId": 2,
          "publicationId": 2,
          "title": "나의 두번째 출판 책",
          "contentPreview": "This is the story of my early life...",
          "coveImageUrl": "https://my_second_book",
          "visibleScope": "PRIVATE",
          "page": 104,
          "createdAt": "2023-01-02T00:00:00Z"
        },
      ],
      "currentPage": 1,
      "totalElements": 1,
      "totalPages": 1,
      "hasNextPage": false,
      "hasPreviousPage": false
    });
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    return PublicationResponse.fromJson(json.decode(responseJson));
  }
}

