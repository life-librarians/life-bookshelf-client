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
  String token = UserPreferences.getUserToken();

  /// Autobiography가 생성되었는 지 확인
  Future<int?> checkAutobiography(int chapterId) async {
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
            return autobiography['autobiographyId'];
          }
        }
        // chapterId를 찾지 못한 경우
        return null;
      }
    } catch (e) {
      throw Exception('자서전 목록 조회 중 오류 발생: $e');
    }
    return null;
  }

  /// Autobiography 생성
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

  Future<Map<String, dynamic>> getNextQuestion(List<Map<String, dynamic>> conversations, List<String> predefinedQuestions) async {
    try {
      final response = await http.post(
        // TODO: API URL 수정 필요 (ai 서버 측)
        Uri.parse(''),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'conversations': conversations,
          'predefinedQuestions': predefinedQuestions,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'nextQuestion': data['nextQuestion'] as String,
          'isPredefined': data['isPredefined'] as bool,
        };
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
