import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../views/login/login_screen.dart';

class RegisterService {
  // 회원가입 정보를 서버로 보내고 결과를 받아오는 함수
  Future<void> postRegister(String email, String password) async {
    String apiUrl = '${dotenv.env['API']}/auth/email-register';

    // MultipartRequest 사용
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..fields['email'] = email
      ..fields['password'] = password;

    // 헤더 추가
    request.headers.addAll({
      'accept': '*/*',
      'Content-Type': 'multipart/form-data',
    });

    // 요청 보내기
    var response = await request.send();

    // 응답 처리
    var responseBodyBytes = await response.stream.toBytes();
    var responseBody = utf8.decode(responseBodyBytes);

    if (response.statusCode == 202) {
      if (responseBody.isNotEmpty) {
        var data = json.decode(responseBody);
        print('Registration successful, verification email sent.');
        Get.to(LoginScreen());
      } else {
        print('Registration successful, but no response body received.');
        Get.to(LoginScreen());
      }
    } else {
      if (responseBody.isNotEmpty) {
        final errorResponse = json.decode(utf8.decode(responseBodyBytes));
        final errorCode = errorResponse['code'] ?? 'Unknown error';
        final errorMessage = errorResponse['message'] ?? 'No specific error message provided';
        throw Exception('Registration failed with error $errorCode: $errorMessage');
      } else {
        throw Exception('Registration failed with unknown error and no response body.');
      }
    }
  }
}
