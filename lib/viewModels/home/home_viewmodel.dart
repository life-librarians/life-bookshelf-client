// home_viewmodel.dart
import 'package:get/get.dart';
import 'package:life_bookshelf/models/home/chapter.dart';
import 'package:life_bookshelf/services/home/chapter_service.dart';

class HomeViewModel extends GetxController {
  final HomeChapterService chapterService;

  var chapters = <HomeChapter>[].obs;
  var currentChapter = Rx<HomeChapter?>(null);
  var isLoading = true.obs;

  HomeViewModel(this.chapterService);

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      await fetchChapters();
      setCurrentChapter();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchChapters() async {
    var fetchedChapters = await chapterService.fetchChapters(0, 10);
    chapters.value = fetchedChapters;
  }

  void setCurrentChapter() {
    if (chapters.isNotEmpty) {
      int? currentId = chapterService.currentChapterId;
      if (currentId != null) {
        currentChapter.value = _findChapterById(currentId);
        if (currentChapter.value != null) {
          print("current chapterid: ${currentChapter.value?.chapterId}");
          print('Current Chapter: ${currentChapter.value?.chapterName}');
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

  HomeChapter? _findChapterById(int id) {
    for (var chapter in chapters) {
      if (chapter.chapterId == id) return chapter;
      for (var subChapter in chapter.subChapters) {
        if (subChapter.chapterId == id) return subChapter;
      }
    }
    return null;
  }

  String getTimeAge(DateTime createdAt) {
    Duration difference = DateTime.now().difference(createdAt);
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
