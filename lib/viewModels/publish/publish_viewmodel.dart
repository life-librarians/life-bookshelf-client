import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_bookshelf/services/image_upload_service.dart';
import 'package:http/http.dart' as http;
import 'package:life_bookshelf/services/userpreferences_service.dart';
import 'package:uuid/uuid.dart';

import '../../services/publish/publish_service.dart';
import '../../utilities/page_calculator.dart';
import '../../utilities/price_calculator.dart';
import '../home/home_viewmodel.dart';

class PublishViewModel extends GetxController {
  final PublishService _publishService = PublishService();

  final ImageUploadService _imageUploadService = Get.find<ImageUploadService>();
  final String baseUrl = dotenv.env['API'] ?? "";
  String token = UserPreferences.getUserToken();

  final RxString bookTitle = ''.obs;
  final RxString titleLocation = '상단'.obs;
  final Rx<XFile?> coverImage = Rx<XFile?>(null);
  final RxList<int> chapterIds = <int>[].obs; // TODO: 챕터 ID 리스트 받아오기

  final RxString memberName = ''.obs;
  final RxString memberBornedAt = ''.obs;

  final RxInt totalSubchapters = 0.obs;
  final RxInt totalPages = 0.obs;
  final RxInt totalPrice = 0.obs;

  @override
  void onInit() {
    final homeViewModel = Get.find<HomeViewModel>();
    super.onInit();
    fetchMemberInfo();
    ever(homeViewModel.chapters, (_) {
      if (homeViewModel.chapters.isNotEmpty) {
        getTotalSubChaptersCount(homeViewModel);
      }
    });
  }


  String get formattedPrice => totalPrice.value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},'
  );

  String get formattedPages => totalPages.value.toString();

  void calculateTotalPages() {
    const int CHARACTERS_PER_SUBCHAPTER = 3000;
    const int CHARACTERS_PER_PAGE = 760;

    int totalCharacters = totalSubchapters.value * CHARACTERS_PER_SUBCHAPTER;
    totalPages.value = (totalCharacters / CHARACTERS_PER_PAGE).ceil();

    // 페이지 수 계산 후 가격 계산
    totalPrice.value = PriceCalculator.calculateTotalPrice(totalPages.value);
  }
  Future<void> fetchMemberInfo() async {
    try {
      final memberInfo = await _publishService.getMemberInfo();
      memberName.value = memberInfo['name'] ?? '';
      memberBornedAt.value = memberInfo['bornedAt'] ?? '';
    } catch (e) {
      print('Error in fetchMemberInfo: $e');
    }
  }
  // 챕터 데이터를 파싱하고 서브챕터 개수를 계산하는 함수
  Future<void> getTotalSubChaptersCount(HomeViewModel viewModel) async {
    int totalCount = 0;

    // chapters 리스트를 순회하면서 각 챕터의 subChapters 개수를 더함
    for (var chapter in viewModel.chapters) {
      totalCount += chapter.subChapters.length;
    }
    totalSubchapters.value = totalCount;

    calculateTotalPages();

  }

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
      String token = UserPreferences.getUserToken();

      // 출판 요청
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/publications/'))
        ..fields['title'] = bookTitle.value
        ..fields['preSignedCoverImageUrl'] = imageUrl
        ..fields['titlePosition'] = titleLocation.value.toUpperCase();
      // ..fields['chapterIds'] = "[1]";

      request.headers.addAll({
        'accept': '*/*',
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
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
