import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:life_bookshelf/models/onboarding/onboarding_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OnboardingApiService {
  final String apiUrl = '${dotenv.env['API']}/api/v1/members/me';

  // 사용자 정보 업데이트 메서드
  Future<void> updateUser(OnUserModel user) async {
    print("Sending request to URL: $apiUrl");

    // 실제 구동 코드 (주석 처리)
    /*
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['name'] = user.name;
    request.fields['bornedAt'] = user.bornedAt.toIso8601String();
    request.fields['gender'] = user.gender;
    request.fields['hasChildren'] = user.hasChildren.toString();

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('회원 정보가 성공적으로 수정되었습니다.');
    } else if (response.statusCode == 400) {
      final errorResponse = jsonDecode(responseBody);
      throw Exception('회원 정보 수정 실패: ${errorResponse['message']}');
    } else {
      throw Exception('회원 정보 수정 실패. 상태 코드: ${response.statusCode}');
    }
    */
    // 테스트용 코드
    print("Request body:");
    print("name: ${user.name}");
    print("bornedAt: ${user.bornedAt}");
    print("gender: ${user.gender}");
    print("hasChildren: ${user.hasChildren}");

    await Future.delayed(Duration(seconds: 4));


  }
}