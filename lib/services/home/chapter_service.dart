import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/home/chapter.dart';

class HomeChapterService {
  final String baseUrl;
  int? currentChapterId;

  HomeChapterService(this.baseUrl);

  Future<List<HomeChapter>> fetchChapters(int page, int size) async {
    var url = Uri.parse('$baseUrl/chapters?page=$page&size=$size');
    var response = await http.get(url);
    /* Uncomment this block to use real API
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      currentChapterId = data['currentChapterId'];
      return (data['results'] as List)
          .map((chapterJson) => Chapter.fromJson(chapterJson))
          .toList();
    } else {
      throw Exception('Failed to load chapters');
    }
    */

    // Comment out or remove this block when using the real API
    String jsonString = '''
    {
        "currentChapterId": 1,
        "results": [
            {
                "chapterId": 1,
                "chapterNumber": 1,
                "chapterName": "Chapter 1: Early Life",
                "chapterCreatedAt": "2023-01-01T00:00:00Z"
            },
            {
                "chapterId": 2,
                "chapterNumber": 2,
                "chapterName": "Chapter 2: Education",
                "chapterCreatedAt": "2023-01-02T00:00:00Z"
            }
        ],
        "currentPage": 1,
        "totalElements": 2,
        "totalPages": 1,
        "hasNextPage": false,
        "hasPreviousPage": false
    }
    ''';
    var data = jsonDecode(jsonString);
    currentChapterId = data['currentChapterId'];
    return (data['results'] as List)
        .map((chapterJson) => HomeChapter.fromJson(chapterJson))
        .toList();
  }
}
