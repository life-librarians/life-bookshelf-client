// home_viewmodel.dart
import 'package:get/get.dart';
import 'package:life_bookshelf/models/home/chapter.dart';
import 'package:life_bookshelf/services/home/chapter_service.dart';
import '../../models/home/autobiography.dart';
import '../../services/home/autobiography_service.dart';

class HomeViewModel extends GetxController {
  final HomeChapterService chapterService;
  final HomeAutobiographyService AutoBiographtService;

  var chapters = <HomeChapter>[].obs;
  var currentChapter = Rx<HomeChapter?>(null);
  var isLoading = true.obs;
  final _chapterToAutobiographyMap = <int, int>{}.obs;

  HomeViewModel(this.chapterService, this.AutoBiographtService);

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
    var fetchedChapters = await chapterService.fetchChapters(0, 100);
    chapters.value = fetchedChapters;
    // print('Chapters:');
    // for (var chapter in chapters) {
    //   print('  Chapter ID: ${chapter.chapterId}');
    //   print('  Chapter Number: ${chapter.chapterNumber}');
    //   print('  Chapter Name: ${chapter.chapterName}');
    //   print('  Description: ${chapter.description}');
    //   print('  Created At: ${chapter.chapterCreatedAt}');
    //   print('  Sub Chapters:');
    //   for (var subChapter in chapter.subChapters) {
    //     print('    Sub Chapter ID: ${subChapter.chapterId}');
    //     print('    Sub Chapter Number: ${subChapter.chapterNumber}');
    //     print('    Sub Chapter Name: ${subChapter.chapterName}');
    //     print('    Sub Description: ${subChapter.description}');
    //     print('    Sub Created At: ${subChapter.chapterCreatedAt}');
    //   }
    //   print('  ---');
    // }
  }

  void setCurrentChapter() {
    if (chapters.isNotEmpty) {
      int? currentId = chapterService.currentChapterId;
      if (currentId != null) {
        currentChapter.value = _findChapterById(currentId);
        if (currentChapter.value != null) {
          print("current chapterid: ${currentChapter.value?.chapterId}");
          print('Current ChapterName: ${currentChapter.value?.chapterName}');
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

  Future<void> fetchAutobiographyMapping() async {
    try {
      // Fetch autobiography data from the API
      final List<HomeAutobiography> autobiographies = await AutoBiographtService.fetchAutobiographies();

      // Clear existing mapping
      _chapterToAutobiographyMap.clear();

      // Create mapping from chapterId to autobiographyId
      for (var autobiography in autobiographies) {
        _chapterToAutobiographyMap[autobiography.autobiographyId] = autobiography.autobiographyId;
      }
    } catch (e) {
      print('Error fetching autobiography mapping: $e');
    }
  }

  // Get autobiographyId for a given chapterId
  int? getAutobiographyId(int chapterId) {
    return _chapterToAutobiographyMap[chapterId];
  }
}
