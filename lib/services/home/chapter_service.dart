// chapter_service.dart
import 'package:http/http.dart' as http;
import 'package:life_bookshelf/services/userpreferences_service.dart';
import 'dart:convert';
import '../../models/home/chapter.dart';

class HomeChapterService {
  final String baseUrl;
  int? currentChapterId;

  HomeChapterService(this.baseUrl);

  Future<List<HomeChapter>> fetchChapters(int page, int size) async {
    // String token = UserPreferences.getUserToken();
    // var url = Uri.parse('$baseUrl/chapters?page=$page&size=$size');

    // try {
    //   var response = await http.get(
    //     url,
    //     headers: {
    //       'accept': '*/*',
    //       'Authorization': 'Bearer $token',
    //       'Content-Type': 'application/json',
    //     },
    //   );
    //   print(token);
    //   if (response.statusCode == 200) {
    //     var data = jsonDecode(utf8.decode(response.bodyBytes));
    //     var currentChapterId = data['currentChapterId'];
    //     print('Current Chapter ID: $currentChapterId');

    //     return (data['results'] as List).map((chapterJson) => HomeChapter.fromJson(chapterJson)).toList();
    //   } else if (response.statusCode == 400) {
    //     final errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
    //     throw Exception('챕터 로딩 실패: ${errorResponse['message']}');
    //   } else {
    //     throw Exception('챕터 로딩 실패. 상태 코드: ${response.statusCode}, ${utf8.decode(response.bodyBytes)}');
    //   }
    // } catch (e) {
    //   print('Error fetching chapters: $e');
    //   throw Exception('챕터를 불러오는 중 오류가 발생했습니다: $e');
    // }

    // 예시 데이터를 사용하는 코드 (주석 처리하지 않음)
    String jsonString = '''
    {
      "currentChapterId": 7,
      "results": [
        {
          "chapterId": 1,
          "chapterNumber": "1",
          "chapterName": "Chapter 1: Early Life",
          "chapterCreatedAt": "2024-07-21T16:15:16.641Z",
          "subChapters": [
            {
              "chapterId": 3,
              "chapterNumber": "1.1",
              "chapterName": "Subchapter 1: Childhood",
              "chapterCreatedAt": "2024-07-21T16:15:16.641Z"
            },
            {
              "chapterId": 4,
              "chapterNumber": "1.2",
              "chapterName": "Subchapter 2: Childhood",
              "chapterCreatedAt": "2024-07-21T16:15:16.641Z"
            }

          ]
        },
        {
          "chapterId": 5,
          "chapterNumber": "2",
          "chapterName": "Chapter 2: Early Life",
          "chapterCreatedAt": "2024-07-21T16:15:16.641Z",
          "subChapters": [
            {
              "chapterId": 6,
              "chapterNumber": "2.1",
              "chapterName": "Subchapter 1: Childhood",
              "chapterCreatedAt": "2024-07-21T16:15:16.641Z"
            },
            {
              "chapterId": 7,
              "chapterNumber": "2.2",
              "chapterName": "Subchapter 2: Childhood",
              "chapterCreatedAt": "2024-07-21T16:15:16.641Z"
            }
          ]
        }
      ]
    }
    ''';
    var data = jsonDecode(jsonString);
    currentChapterId = data['currentChapterId'];
    return (data['results'] as List).map((chapterJson) => HomeChapter.fromJson(chapterJson)).toList();
  }
}
