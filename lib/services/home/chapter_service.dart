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
    String token = UserPreferences.getUserToken();
    var url = Uri.parse('$baseUrl/autobiographies/chapters?page=$page&size=$size');

    try {
      var response = await http.get(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(token);
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // currentChapterId = data['currentChapterId'];
        //TODO: currentChapterId 상수값 변경 필요
        currentChapterId = 8;
        print('Current Chapter ID: $currentChapterId');

        return (data['results'] as List).map((chapterJson) => HomeChapter.fromJson(chapterJson)).toList();
      } else if (response.statusCode == 400) {
        final errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception('챕터 로딩 실패: ${errorResponse['message']}');
      } else {
        throw Exception('챕터 로딩 실패. 상태 코드: ${response.statusCode}, ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      print('Error fetching chapters: $e');
      throw Exception('챕터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }
}
