import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:life_bookshelf/models/chatting/conversation_model.dart';
import 'package:life_bookshelf/models/home/chapter.dart';
import 'package:life_bookshelf/services/image_upload_service.dart';
import 'package:life_bookshelf/services/userpreferences_service.dart';

class ChattingService extends GetxService {
  final ImageUploadService _imageUploadService = Get.find<ImageUploadService>();

  final String baseUrl = dotenv.env['API'] ?? "";
  final String aiUrl = dotenv.env['AI'] ?? "";
  String token = UserPreferences.getUserToken();
  final Map<String, dynamic> userInfo = <String, dynamic>{}.obs;

  final Map<String, dynamic> bodyinfo = {
    "occupation": "프로그래머",
    "education_level": "대학교 재학",
    "marital_status": "미혼",
    'chapter_info': {
      "title": "대학교 입학 전, 어린기와 청소년 시절",
      "description": "황현정으로써 살아온 어린 시절과 청소년 시절에 대한 이야기",
    },
    'sub_chapter_info': {
      "title": "초등학교 입학",
      "description": "황현정이 초등학교에 입학하고, 중학교에 들어가기 전까지 학교를 다니며 겪은 일들에 대한 이야기",
    }
  };

  Future<Map<String, dynamic>> getInterview(int interviewId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/interviews/$interviewId/questions'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = responseData;
        return data;
      } else {
        throw Exception('인터뷰 정보를 불러오는 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('인터뷰 정보를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  /// Autobiography가 생성되었는 지 확인
  Future<(int?, int?)> checkAutobiography(int chapterId) async {
    // 전체 자서전 목록 조회 후, 해당 chapterId가 있는지 확인
    try {
      final response = await http.get(Uri.parse('$baseUrl/autobiographies'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // 응답 본문을 JSON으로 디코딩
        final Map<String, dynamic> autobiographies = jsonDecode(response.body);

        // 각 자서전을 순회하며 chapterId가 있는지 확인
        for (var autobiography in autobiographies['results']) {
          if (autobiography['chapterId'] == chapterId) {
            // chapterId가 있는 경우 autobiographyId 반환
            int interviewId = autobiography['interviewId'];
            int autobiographyId = autobiography['autobiographyId'];
            return (autobiographyId, interviewId);
          }
        }
        // chapterId를 찾지 못한 경우
        return (null, null);
      }
    } catch (e) {
      throw Exception('자서전 목록 조회 중 오류 발생: $e');
    }
    return (null, null);
  }

  Future<void> saveConversation(List<Conversation> conversations, int interviewId) async {
    print(interviewId);
    try {
      final response = await http.post(Uri.parse('$baseUrl/interviews/$interviewId/conversations'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'conversations': getLastTwo(conversations)
                .map((conv) => {
                      'content': conv.content,
                      'conversationType': conv.conversationType == 'AI' ? 'BOT' : "HUMAN",
                    })
                .toList(),
          }));

      if (response.statusCode == 201) {
        print('대화 저장 성공');
      } else {
        print(utf8.decode(response.bodyBytes));
        throw Exception('대화 저장 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('대화 저장 중 오류가 발생했습니다: $e');
    }
  }

  Future<int> createAutobiography(HomeChapter chapter) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/autobiographies'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'chapterId': chapter.chapterId,
            'title': chapter.chapterName,
            'description': chapter.description,
          }));

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['autobiographyId'] as int;
      } else {
        throw Exception('자서전 생성 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('자서전 생성 중 오류가 발생했습니다: $e');
    }
  }

  // TODO: Pagination에 따른 Paging 구현 필요
  Future<List<Conversation>> getConversations(int interviewId, int page, int size) async {
    try {
      print(token);
      final response = await http.get(Uri.parse('$baseUrl/interviews/$interviewId/conversations?page=$page&size=$size'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> results = data['results'];
        return results
            .map((item) => Conversation(
                  conversationType: item['conversationType'] == 'BOT' ? 'AI' : 'HUMAN',
                  content: item['content'],
                  timestamp: DateTime.parse(item['createdAt']),
                ))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('BIO008: 자서전 ID가 존재하지 않습니다.');
      } else if (response.statusCode == 403) {
        throw Exception('BIO009: 해당 자서전의 주인이 아닙니다.');
      } else {
        throw Exception('서버 오류가 발생했습니다.');
      }
    } catch (e) {
      throw Exception('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  Future<String> getNextQuestion(List<Map<String, dynamic>> conversations, List<dynamic> predefinedQuestions, HomeChapter chapter) async {
    if (userInfo.isEmpty) {
      final response = await http.get(Uri.parse('$baseUrl/members/me'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        userInfo['name'] = data['name'];
        userInfo['bornedAt'] = data['bornedAt'];
        userInfo['gender'] = data['gender'];
        userInfo['hasChildren'] = data['hasChildren'];
      }
      print("userInfo: $userInfo");
    }
    final url = '$aiUrl/interviews/interview-chat';

    final body = jsonEncode({
      'user_info': {
        "user_name": userInfo['name'],
        "date_of_birth": userInfo['bornedAt'],
        "gender": userInfo['gender'],
        "has_children": userInfo['hasChildren'],
        "occupation": bodyinfo["occupation"],
        "education_level": bodyinfo["education_level"],
        "marital_status": bodyinfo["marital_status"],
      },
      'chapter_info': bodyinfo['chapter_info'],
      'sub_chapter_info': bodyinfo['sub_chapter_info'],
      'conversation_history': convertConversationFormat(conversations),
      'current_answer': conversations.last['content'],
      'question_limit': 1
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final String data = utf8.decode(response.bodyBytes);
        print("생성된 질문: $data");
        return data;
      } else {
        print(utf8.decode(response.bodyBytes));
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
      throw Exception('다음 질문을 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  /// presigned URL을 통해 이미지를 S3에 업로드
  Future<String> uploadImage(File imageFile) async {
    return await _imageUploadService.uploadImage(imageFile, ImageUploadFolder.bioCoverImages);
  }

  /// AI 서버 req 형식에 따라 변환
  List<Map<String, dynamic>> convertConversationFormat(List<Map<String, dynamic>> originalList) {
    return originalList.map((item) {
      // conversationType을 conversation_type으로 변환
      String conversationType = item['conversationType'] == 'AI' ? 'BOT' : 'HUMAN';

      // 새로운 형식의 맵 생성
      return {
        'content': item['content'],
        'conversation_type': conversationType,
      };
    }).toList();
  }
}

List<T> getLastTwo<T>(List<T> list) {
  if (list.length < 2) {
    return List.from(list); // 리스트의 모든 요소 반환 (0개 또는 1개)
  }
  return list.sublist(list.length - 2);
}
