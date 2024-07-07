import 'package:get/get.dart';
import 'package:life_bookshelf/models/chatting/conversation_model.dart';

class ApiService extends GetxService {
  final String baseUrl = 'YOUR_BASE_URL';

  Future<List<Conversation>> getConversations(int autobiographyId, int page, int size) async {
    try {
      final response = await get('$baseUrl/api/v1/interviews/autobiographies/$autobiographyId/conversations?page=$page&size=$size');

      if (response.status.hasError) {
        if (response.statusCode == 404) {
          throw Exception('BIO008: 자서전 ID가 존재하지 않습니다.');
        } else if (response.statusCode == 403) {
          throw Exception('BIO009: 해당 자서전의 주인이 아닙니다.');
        } else {
          throw Exception('서버 오류가 발생했습니다.');
        }
      }

      final Map<String, dynamic> data = response.body;
      final List<dynamic> results = data['results'];
      return results.map((item) => Conversation.fromJson(item)).toList();
    } catch (e) {
      throw Exception('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }
}
