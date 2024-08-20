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
        "title": "테스트 자서전",
        "content": "이것은 테스트 내용입니다.",
        "interviewQuestions": [
          {"order": 1, "questionText": "당신의 이름은 무엇인가요?"},
        ],
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
