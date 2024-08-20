import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_bookshelf/services/image_upload_service.dart';
import 'package:http/http.dart' as http;
import 'package:life_bookshelf/services/userpreferences_service.dart';
import 'package:uuid/uuid.dart';

class PublishViewModel extends GetxController {
  final ImageUploadService _imageUploadService = Get.find<ImageUploadService>();
  final String baseUrl = dotenv.env['API'] ?? "";
  String token = UserPreferences.getUserToken();

  final RxString bookTitle = ''.obs;
  final RxString titleLocation = '상단'.obs;
  final Rx<XFile?> coverImage = Rx<XFile?>(null);
  final RxList<int> chapterIds = <int>[].obs; // TODO: 챕터 ID 리스트 받아오기

  void setBookTitle(String title) {
    bookTitle.value = title;
  }

  void setTitleLocation(String location) {
    titleLocation.value = location;
  }

  //! For Testing
  Future<void> test() async {
    final String baseUrl = dotenv.env['API'] ?? "";
    print('Test');
    try {
      final Map<String, dynamic> requestBody = {
        "title": "20대의 대학 생활과 프로그래머 취업",
        "content": "20대에 대학을 다니고 졸업을 하여 프로그래머로 취업하고, 그 후 일어나는 일들.",
        "interviewQuestions": [
          {"order": 1, "questionText": "어떤 동기로 대학에 진학하게 되었나요?"},
          {"order": 2, "questionText": "대학 시절 가장 기억에 남는 수업이나 교수는 누구였나요?"},
          {"order": 3, "questionText": "대학 생활 중 특별히 어려웠던 순간은 무엇이었나요?"},
          {"order": 4, "questionText": "프로그래밍을 처음 접하게 된 계기는 무엇인가요?"},
          {"order": 5, "questionText": "프로그래머로서의 커리어를 결심하게 된 이유는 무엇인가요?"},
          {"order": 6, "questionText": "첫 취업 준비 과정에서 겪은 가장 큰 도전은 무엇이었나요?"},
          {"order": 7, "questionText": "첫 직장에서 맡은 주요 프로젝트는 무엇이었나요?"},
          {"order": 8, "questionText": "취업 후 가장 큰 성취감이나 보람을 느낀 순간은 언제였나요?"},
          {"order": 9, "questionText": "직장 생활을 통해 얻은 가장 큰 교훈은 무엇인가요?"},
          {"order": 10, "questionText": "미래의 프로그래머들에게 해주고 싶은 조언이 있다면 무엇인가요?"}
        ],
        "chapterId": 9
      };

      print('Request Body: ${jsonEncode(requestBody)}'); // 요청 본문 로깅

      final response = await http.post(
        Uri.parse('$baseUrl/autobiographies'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        print('자서전이 성공적으로 생성되었습니다.');
      } else {
        final decodedBody = utf8.decode(response.bodyBytes);
        print('오류 응답 본문: $decodedBody');

        try {
          final errorData = jsonDecode(decodedBody);
          print('구조화된 오류 데이터: $errorData');
        } catch (e) {
          print('오류 응답을 JSON으로 파싱할 수 없습니다: $e');
        }

        throw Exception('자서전 생성 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('예외 발생: $e');
      throw Exception('자서전 생성 중 오류 발생: $e');
    }
  }

  // Future<void> test() async {
  //   final String baseUrl = dotenv.env['API'] ?? "";
  //   print('Test');
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/autobiographies/chapters'),
  //       headers: <String, String>{
  //         'accept': '*/*',
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         "chapters": [
  //           {
  //             "number": "1",
  //             "name": "나의 첫번째 챕터",
  //             "subchapters": [
  //               {"number": "1.1", "name": "나의 첫번째 서브챕터"},
  //               {"number": "1.2", "name": "나의 두번째 서브챕터"}
  //             ]
  //           },
  //           {
  //             "number": "2",
  //             "name": "나의 두번째 챕터",
  //             "subchapters": [
  //               {"number": "2.1", "name": "나의 첫번째 서브챕터"},
  //               {"number": "2.2", "name": "나의 두번째 서브챕터"}
  //             ]
  //           }
  //         ]
  //       }),
  //     );

  //     if (response.statusCode == 201) {
  //       print(response.body);
  //     } else {
  //       print('Error response body: ${response.body}'); // 오류 응답 내용 출력
  //       throw Exception('error on test. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error on test: $e');
  //   }
  // }

  Future<void> pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        coverImage.value = image;
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> proceedPublication() async {
    try {
      if (coverImage.value == null) {
        throw Exception('커버 이미지를 선택해주세요.');
      }

      // 이미지 S3 업로드
      final String imageUrl = await _imageUploadService.uploadImage(File(coverImage.value!.path), ImageUploadFolder.bookCoverImages);

      // 출판 요청
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/publications'))
        ..fields['title'] = bookTitle.value
        ..fields['preSignedCoverImageUrl'] = imageUrl
        ..fields['titlePosition'] = titleLocation.value.toUpperCase();
      // ..fields['chapterIds'] = "[1]";

      request.headers.addAll({
        'accept': '*/*',
        'Content-Type': 'multipart/form-data',
      });

      var response = await request.send();

      // 응답 처리
      var responseBodyBytes = await response.stream.toBytes();
      var responseBody = utf8.decode(responseBodyBytes);

      print('Response: $responseBody');

      if (response.statusCode == 201) {
        Get.snackbar('성공', '출판이 성공적으로 완료되었습니다.');
      } else {
        final errorData = json.decode(responseBody);
        throw Exception('${errorData['message']} (${errorData['code']})');
      }
    } catch (e) {
      print('Error publishing book: ${e.toString()}');
      Get.snackbar('오류', e.toString());
    }
  }
}
