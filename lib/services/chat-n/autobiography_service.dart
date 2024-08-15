import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/chat-n/autobiography_model.dart';
import '../userpreferences_service.dart';

class ChatAutobiographyService {
  // 특정 자서전 상세 정보 조회
  Future<ChatAutobiography> fetchAutobiography(int autobiographyId) async {
    String apiUrl = '${dotenv.env['API']}/autobiographies/$autobiographyId';
    String token = UserPreferences.getUserToken();

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ChatAutobiography.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('BIO008: 자서전 ID가 존재하지 않습니다.');
    } else if (response.statusCode == 403) {
      throw Exception('BIO009: 해당 자서전의 주인이 아닙니다.');
    } else {
      if (response.body.isNotEmpty) {
        final errorResponse = json.decode(utf8.decode(response.bodyBytes));
        final errorCode = errorResponse['code'] ?? 'Unknown error';
        final errorMessage = errorResponse['message'] ?? 'No specific error message provided';
        throw Exception('Failed to load autobiography with error $errorCode: $errorMessage');
      } else {
        throw Exception('Failed to load autobiography with status code ${response.statusCode} and no response body.');
      }
    }
  }

  // 자서전 내용 교정/교열
  Future<List<Map<String, dynamic>>> proofreadAutobiographyContent(int autobiographyId, String content) async {
    String apiUrl = '${dotenv.env['AI']}/autobiographies/proofreading';
    String token = UserPreferences.getUserToken();

    // HttpClient 사용
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse(apiUrl));

    // 헤더 설정
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');

    // JSON body 설정
    request.add(utf8.encode(jsonEncode({
      'content': content,
    })));

    // 응답 받기
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(responseBody);

      // 응답이 Map일 경우 처리
      if (jsonResponse is Map<String, dynamic>) {
        return [jsonResponse];
      } else if (jsonResponse is List) {
        final result = jsonResponse.map((correction) => {
          'original': correction['original'] ?? '',
          'corrected': correction['corrected'] ?? '',
        }).toList();
        // 결과 출력
        print("Proofread Result: $result");
        return result;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to proofread content $responseBody');
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
