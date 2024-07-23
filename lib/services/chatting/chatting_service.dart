import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:life_bookshelf/models/chatting/conversation_model.dart';
import 'package:uuid/uuid.dart';

class ChattingService extends GetxService {
  // TODO: Null Checking
  final String baseUrl = dotenv.env['API'] ?? "";

  // TODO: Pagination에 따른 Paging 구현 필요
  Future<List<Conversation>> getConversations(int autobiographyId, int page, int size) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/interviews/autobiographies/$autobiographyId/conversations?page=$page&size=$size'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((item) => Conversation.fromJson(item)).toList();
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

  /// Presigned URL을 통해 이미지 업로드
  Future<String> getPresignedUrl(File imageFile) async {
    final String fileName = imageFile.path.split('/').last;
    final String randomString = const Uuid().v4();
    final String key = 'bio-cover-images/$randomString/$fileName';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/images/presigned-url'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'imageUrl': key,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['presignedUrl'] as String;
      } else {
        throw Exception('Failed to get presigned URL. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting presigned URL: $e');
    }
  }

  Future<void> uploadToS3(String presignedUrl, File imageFile) async {
    try {
      final request = http.MultipartRequest('PUT', Uri.parse(presignedUrl));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Successfully uploaded image to S3');
      } else {
        throw Exception('Failed to upload image to S3. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image to S3: $e');
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      final presignedUrl = await getPresignedUrl(imageFile);
      await uploadToS3(presignedUrl, imageFile);
      return presignedUrl;
    } catch (e) {
      throw Exception('Error in image upload process: $e');
    }
  }
}
