

import 'package:life_bookshelf/models/onboarding/onboarding_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OnboardingApiService {
  final String apiUrl = "http://your-api-url.com/updateUser";

  // 사용자 정보 업데이트 메서드
  Future<void> updateUser(OnUserModel user) async {
    print("Sending request to URL: $apiUrl");
    print("Request body: ${jsonEncode(user.toJson())}");

    // final response = await http.post(
    //   Uri.parse(apiUrl),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(user.toJson()),
    // );

    // 서버 응답 시뮬레이션
    int simulatedStatusCode = 200; // 테스트를 위해 상태 코드를 설정

    if (simulatedStatusCode == 200) {
      // 성공 시 처리를 시뮬레이션
      print('회원 정보가 성공적으로 수정되었습니다.');
    } else {
      // 실패 시 에러 처리를 시뮬레이션
      print('Failed to update user info. Status Code: $simulatedStatusCode');
    }
  }
}
