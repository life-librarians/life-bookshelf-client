import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterService {
  // 회원가입 정보를 서버로 보내고 결과를 받아오는 함수
  Future<void> postRegister(String email, String password) async {
    String apiUrl = '${dotenv.env['API']}/api/v1/auth/register';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 202) {
      print('Registration successful, verification email sent.');
    } else {
      final errorResponse = json.decode(response.body);
      final errorCode = errorResponse['code'] ?? 'Unknown error';
      final errorMessage = errorResponse['message'] ?? 'No specific error message provided';
      throw Exception('Registration failed with error $errorCode: $errorMessage');
    }
  }
}
