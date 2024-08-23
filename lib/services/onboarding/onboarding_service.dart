import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:life_bookshelf/models/onboarding/onboarding_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../userpreferences_service.dart';

class OnboardingApiService {
  final String apiUrl = '${dotenv.env['AI']}/chapters/generate_chapters';
  final String ChapterApiUrl = '${dotenv.env['API']}/autobiographies/chapters';

  late List<dynamic> chapterTimeline;

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

    // final response = await http.post(
    //   Uri.parse(apiUrl),
    //   headers: headers,
    //   body: body,
    // );

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('온보딩을 바탕으로 챕터가 성공적으로 생성되었습니다.');

      final Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));

      // 콘솔에 출력
      chapterTimeline = responseData['chapter_timeline'];
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
  Future<void> createChapter() async {
    if (chapterTimeline == null) throw Exception('chapterTimeline이 비어있습니다.');

    // chapterTimeline 데이터를 변환
    List<Map<String, dynamic>> chapters = [];
    for (int i = 0; i < chapterTimeline.length; i++) {
      var chapter = chapterTimeline[i];
      List<Map<String, dynamic>> subchapters = [];

      // 서브챕터 변환
      for (int j = 0; j < chapter['key_events'].length; j++) {
        var event = chapter['key_events'][j];
        subchapters.add({
          'number': '${i + 1}.${j + 1}',
          'name': event['event_title'],
        });
      }
      // 메인 챕터 변환
      chapters.add({
        'number': '${i + 1}',
        'name': chapter['chapter_title'],
        'subchapters': subchapters,
      });
    }

    // 최종 데이터를 JSON 형식으로 준비
    final body = jsonEncode({'chapters': chapters});

    String token = UserPreferences.getUserToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(ChapterApiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      print('서버에 챕터가 성공적으로 생성 요청되었습니다.');
    } else {
      final decodedResponse = utf8.decode(response.bodyBytes);
      throw Exception('챕터 생성 실패. 상태 코드: ${response.statusCode}, 응답 내용: $decodedResponse');
    }
  }


}
