import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:life_bookshelf/models/chatting/conversation_model.dart';

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
}
