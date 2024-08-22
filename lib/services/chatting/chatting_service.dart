import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:life_bookshelf/models/chatting/conversation_model.dart';
import 'package:life_bookshelf/models/home/chapter.dart';
import 'package:life_bookshelf/services/image_upload_service.dart';
import 'package:life_bookshelf/services/userpreferences_service.dart';
import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';

class ChattingService extends GetxService {
  final ImageUploadService _imageUploadService = Get.find<ImageUploadService>();

  final String baseUrl = dotenv.env['API'] ?? "";
  final String aiUrl = dotenv.env['AI'] ?? "";
  String token = UserPreferences.getUserToken();
  final Map<String, dynamic> userInfo = <String, dynamic>{}.obs;

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

  //! Autobiography 생성 -> 삭제 예정
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
            // 'content': chapter.,
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
  Future<List<Conversation>> getConversations(int autobiographyId, int page, int size) async {
    try {
      print(token);
      final response =
          // ! API URL 수정 필요
          await http.get(Uri.parse('$baseUrl/interviews/$autobiographyId/conversations?page=$page&size=$size'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((item) => Conversation.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('BIO008: 자서전 ID가 존재하지 않습니다.');
      } else if (response.statusCode == 403) {
        throw Exception('BIO009: 해당 자서전의 주인이 아닙니다.');
      } else {
        print(response.body);
        throw Exception('서버 오류가 발생했습니다.');
      }
    } catch (e) {
      throw Exception('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  Future<Map<String, dynamic>> getNextQuestion(
      List<Map<String, dynamic>> conversations, List<dynamic> predefinedQuestions, HomeChapter chapter) async {
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

    try {
      final response = await http.post(
        // TODO: API URL 수정 필요 (ai 서버 측)
        Uri.parse('$aiUrl/interviews/interview-questions'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_info': {
            "user_name": userInfo['name'],
            "date_of_birth": userInfo['bornedAt'],
            "gender": userInfo['gender'],
            "has_children": userInfo['hasChildren'],
            "occupation": "프로그래머", //TODO: 온보딩 수정 시 정보 추가
            "education_level": "대학교 재학",
            "marital_status": "미혼",
          },
          'chapter_info': {
            "chapter_id": chapter.chapterId,
            "chapter_name": chapter.chapterName,
          },
          'conversation_history': conversations,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        print("생성된 질문: $data");
        return {
          'nextQuestion': data['nextQuestion'] as String,
          'isPredefined': data['isPredefined'] as bool,
        };
      } else if (response.statusCode == 422) {
        print(response.body);
        throw Exception('Validation Error: ${response.body}');
      } else {
        throw Exception('서버 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('다음 질문을 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  /// presigned URL을 통해 이미지를 S3에 업로드
  Future<String> uploadImage(File imageFile) async {
    return await _imageUploadService.uploadImage(imageFile, ImageUploadFolder.bioCoverImages);
  }
}
