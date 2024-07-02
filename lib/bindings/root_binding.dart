import 'package:get/get.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';
import 'package:life_bookshelf/viewModels/publish/publish_viewmodel.dart';
import 'package:life_bookshelf/viewModels/root/root_viewmodel.dart';
import 'package:life_bookshelf/services/chapter_service.dart';
import 'package:life_bookshelf/services/autobiography_service.dart';


class RootBinding extends Bindings {
  @override
  void dependencies() {
    const String baseUrl = 'https://jsonplaceholder.typicode.com';
    // ParentViewModel is singleton
    Get.put(RootViewModel());

    // ChildViewModel is singleton
    Get.put(HomeViewModel(ChapterService(baseUrl), AutobiographyService(baseUrl)));
    Get.put(MypageViewModel());
    Get.put(PublishViewModel());
  }
}
