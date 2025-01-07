import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../userpreferences_service.dart';

class PublishService {
  final String baseUrl = dotenv.env['API'] ?? '';

  // 회원 정보를 가져오는 함수
  Future<Map<String, dynamic>> getMemberInfo() async {
    try {
      final token = await UserPreferences.getUserToken();

      final response = await http.get(
        Uri.parse('$baseUrl/members/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to fetch member info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching member info: $e');
    }
  }
}