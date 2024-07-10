import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/login/login_model.dart';
import '../userpreferences_service.dart';

class LoginService {
  // 로그인 정보를 서버로 보내고 결과를 받아오는 함수
  Future<Login> postLogin(String email, String password) async {
    String apiUrl = '${dotenv.env['API']}/api/v1/auth/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      await UserPreferences.setUserToken(response.body);
      return Login.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('BIO008: 존재하지 않는 회원입니다.');
    } else if (response.statusCode == 403) {
      throw Exception('BIO009: 이메일 인증이 완료되지 않은 사용자입니다.');
    } else if (response.statusCode == 401) {
      throw Exception('AUTH006: 이메일 또는 비밀번호가 일치하지 않습니다.');
    } else if (response.statusCode == 400) {
      final errorResponse = json.decode(response.body);
      switch (errorResponse['code']) {
        case 'AUTH001':
          throw Exception('AUTH001: 이메일 형식이 올바른지 다시 확인해주세요. 옳은 예: john.doe@example.com');
        case 'AUTH002':
          throw Exception('AUTH002: 이메일은 최대 64자까지 입력할 수 있습니다.');
        case 'AUTH003':
          throw Exception('AUTH003: 비밀번호는 영문, 숫자, 특수문자를 포함하여 최소 8자 이상, 최대 64자 이하까지 입력할 수 있습니다.');
        default:
          throw Exception('Unknown error occurred with error code ${errorResponse['code']}');
      }
    } else {
      throw Exception('Failed to login with error code ${response.statusCode}');
    }
  }
}
