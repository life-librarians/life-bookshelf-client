import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_bookshelf/services/image_upload_service.dart';
import 'package:http/http.dart' as http;

class PublishViewModel extends GetxController {
  final ImageUploadService _imageUploadService = Get.find<ImageUploadService>();
  final String baseUrl = dotenv.env['API'] ?? "";

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
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/publications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'preSignedImageUrl': imageUrl,
          'titlePosition': titleLocation.value.toUpperCase(),
          'chapterIds': chapterIds,
        }),
      );

      if (response.statusCode == 201) {
        Get.snackbar('성공', '출판이 성공적으로 완료되었습니다.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception('${errorData['message']} (${errorData['code']})');
      }
    } catch (e) {
      Get.snackbar('오류', e.toString());
    }
  }
}
