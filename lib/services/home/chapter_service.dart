// chapter_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/home/chapter.dart';

class HomeChapterService {
  final String baseUrl;
  int? currentChapterId;

  HomeChapterService(this.baseUrl);

  Future<List<HomeChapter>> fetchChapters(int page, int size) async {
    // 실제 API 호출 코드 (현재는 주석 처리)
    /*
    var url = Uri.parse('$baseUrl/chapters?page=$page&size=$size');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      currentChapterId = data['currentChapterId'];
      return (data['results'] as List)
          .map((chapterJson) => HomeChapter.fromJson(chapterJson))
          .toList();
    } else {
      throw Exception('Failed to load chapters');
    }
    */

    // 예시 데이터를 사용하는 코드 (주석 처리하지 않음)
    String jsonString = '''
    {
      "currentChapterId": 3,
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
    return (data['results'] as List)
        .map((chapterJson) => HomeChapter.fromJson(chapterJson))
        .toList();
  }
}
