import 'package:get/get.dart';
import 'package:life_bookshelf/models/home/chapter.dart';
import 'package:life_bookshelf/models/home/autobiography.dart';
import 'package:life_bookshelf/services/home/chapter_service.dart';
import 'package:life_bookshelf/services/home/autobiography_service.dart';

import '../../services/userpreferences_service.dart';
import '../../views/login/login_screen.dart';

class HomeViewModel extends GetxController {
  final HomeChapterService chapterService;
  final HomeAutobiographyService autobiographyService;

  var chapters = <HomeChapter>[].obs;
  var autobiographies = <int, List<HomeAutobiography>>{}.obs;
  var currentChapter = Rx<HomeChapter?>(null);
  var isLoading = true.obs;

  HomeViewModel(this.chapterService, this.autobiographyService);

  // Todo: 메인화면으로 가고 싶으면 밑에 isLoggedIn() 없애주세요!!! 토큰이 없으면 무조건 저기로 갑니다
  @override
  void onInit() {
    super.onInit();
    fetchAllData().then((_) {
      if (!_isLoggedIn()) {
        Get.offAll(() => LoginScreen());
      }
    });
  }

  bool _isLoggedIn() {
    String token = UserPreferences.getUserToken(); // 토큰 가져오기
    print("token : " + token);
    return token.isNotEmpty; // 토큰 존재 여부 확인
  }

  Future<void> fetchAllData() async {
    try {
      await fetchChapters();
      await fetchAutobiographiesForAllChapters();
      setCurrentChapter();
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchChapters() async {
    var fetchedChapters = await chapterService.fetchChapters(1, 10);
    chapters.value = fetchedChapters;
    print('Fetched chapters: $chapters');
    for (var chapter in fetchedChapters) {
      autobiographies[chapter.chapterId] = <HomeAutobiography>[];
    }
  }

  Future<void> fetchAutobiographiesForAllChapters() async {
    for (var chapter in chapters) {
      var chapterAutobiographies = await autobiographyService
          .fetchAutobiographies(chapter.chapterId);
      autobiographies[chapter.chapterId] = chapterAutobiographies;
      print('Autobiographies for Chapter ${chapter
          .chapterId}: ${autobiographies[chapter.chapterId]}');
    }
  }

  // Set the current chapter based on the 'currentChapterId' from API
  void setCurrentChapter() {
    if (chapters.isNotEmpty) {
      int? currentId = chapterService.currentChapterId;
      if (currentId != null) {
        currentChapter.value = chapters.firstWhere(
              (chapter) => chapter.chapterId == currentId,
          orElse: () => chapters.first, // 기본 값을 제공
        );
        if (currentChapter.value != null) {
          print('Current Chapter: ${currentChapter.value}');
        } else {
          print('No matching chapter found for the currentChapterId.');
        }
      } else {
        print('No currentChapterId found in the chapters.');
      }
    } else {
      print('Chapter list is empty.');
    }
  }

  String getTimeAge(DateTime updatedAt) {
    Duration difference = DateTime.now().difference(updatedAt);
    String timeAgo;

    if (difference.inMinutes < 60) {
      timeAgo = "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      timeAgo = "${difference.inHours} hours ago";
    } else if (difference.inDays < 30) {
      timeAgo = "${difference.inDays} days ago";
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      timeAgo = "$months months ago";
    } else {
      int years = (difference.inDays / 365).floor();
      timeAgo = "$years years ago";
    }
    return timeAgo;
  }
}