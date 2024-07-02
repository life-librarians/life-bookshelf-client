import 'package:life_bookshelf/services/chapter_service.dart';
import 'package:life_bookshelf/services/autobiography_service.dart';
import 'package:life_bookshelf/models/chapter.dart';
import 'package:life_bookshelf/models/autobiography.dart';
import 'package:get/get.dart';


class HomeViewModel extends GetxController {
  final ChapterService chapterService;
  final AutobiographyService autobiographyService;

  var chapters = <Chapter>[].obs;
  var autobiographies = <int, List<Autobiography>>{}.obs;
  var currentChapter = Rx<Chapter?>(null); // Observable for currently featured chapter

  HomeViewModel(this.chapterService, this.autobiographyService);

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    await fetchChapters();
    await fetchAutobiographiesForAllChapters();
    setCurrentChapter();
  }

  Future<void> fetchChapters() async {
    var fetchedChapters = await chapterService.fetchChapters(1, 10);
    chapters.value = fetchedChapters;
    print('Fetched chapters: $chapters');
    for (var chapter in fetchedChapters) {
      autobiographies[chapter.chapterId] = <Autobiography>[];
    }
  }

  Future<void> fetchAutobiographiesForAllChapters() async {
    for (var chapter in chapters) {
      var chapterAutobiographies = await autobiographyService.fetchAutobiographies(chapter.chapterId);
      autobiographies[chapter.chapterId] = chapterAutobiographies;
      print('Autobiographies for Chapter ${chapter.chapterId}: ${autobiographies[chapter.chapterId]}');
    }
  }

  void setCurrentChapter() {
    if (chapters.isNotEmpty) {
      int? currentId = chapterService.currentChapterId;
      if (currentId != null) {
        currentChapter.value = chapters.firstWhere(
              (chapter) => chapter.chapterId == currentId,
          orElse: () => chapters.first,
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
}
