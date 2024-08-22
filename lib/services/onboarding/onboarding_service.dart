import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:life_bookshelf/models/onboarding/onboarding_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../userpreferences_service.dart';

class OnboardingApiService {
  final String apiUrl = '${dotenv.env['AI']}/chapters/generate_chapters';

  Future<List<dynamic>?> updateUser(OnUserModel user) async {
    String token = UserPreferences.getUserToken();

    final headers = {
      'Authorization': 'Bearer $token',
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'gender': user.gender,
      'user_name': user.name,
      'date_of_birth': user.bornedAt,
      'has_children': user.hasChildren,
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('온보딩을 바탕으로 챕터가 성공적으로 생성되었습니다.');

      final Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));

      // 콘솔에 출력
      List<dynamic> chapterTimeline = responseData['chapter_timeline'];
      for (var chapter in chapterTimeline) {
        print('Chapter Title: ${chapter['chapter_title']}');
        print('Description: ${chapter['description']}');
        List<dynamic> keyEvents = chapter['key_events'];
        for (var event in keyEvents) {
          print('  Event Title: ${event['event_title']}');
          print('  Event Description: ${event['event_description']}');
        }
        print(''); // 챕터 구분을 위한 빈 줄
      }

      // TODO: 챕터 데이터 활용하여 자서전 생성 중이라는 것을 로딩 화면에 표시
      return chapterTimeline;
    } else if (response.statusCode == 400) {
      final errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception('온보딩을 바탕으로 챕터 생성 실패: ${errorResponse['message']}');
    } else {
      throw Exception('온보딩을 바탕으로 챕터 생성 실패. 상태 코드: ${response.statusCode}, ${utf8.decode(response.bodyBytes)}');
    }
  }

  /// 챕터 생성
  Future<void> createChapter() async {}
}
