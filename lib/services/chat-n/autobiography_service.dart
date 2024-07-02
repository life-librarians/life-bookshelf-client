import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../models/chat-n/autobiography_model.dart';

class ChatAutobiographyService {
  // 특정 자서전 상세 정보 조회
  Future<ChatAutobiography> fetchAutobiography(int autobiographyId) async {
    String apiUrl =
        '${dotenv.env['API']}/api/v1/autobiographies/$autobiographyId';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return ChatAutobiography.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('BIO008: 자서전 ID가 존재하지 않습니다.');
    } else if (response.statusCode == 403) {
      throw Exception('BIO009: 해당 자서전의 주인이 아닙니다.');
    } else {
      // 에러 처리
      throw Exception('Failed to load autobiography');
    }
  }

  Future<void> updateAutobiography(
      int id, String title, String content, String coverImageUrl) async {
    String apiUrl = '${dotenv.env['API']}/api/v1/autobiographies/$id';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'prisignedCoverImageUrl': coverImageUrl,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update autobiography');
    }
  }
}
