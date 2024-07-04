import 'package:get/get.dart';
import 'package:life_bookshelf/viewModels/chatting/chatting_viewmodel.dart';
import 'package:life_bookshelf/viewModels/chat-n/autobiography_viewmodel.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';
import 'package:life_bookshelf/viewModels/publish/publish_viewmodel.dart';
import 'package:life_bookshelf/viewModels/root/root_viewmodel.dart';
import 'package:life_bookshelf/views/chatting/chatting_screen.dart';
import 'package:life_bookshelf/services/home/chapter_service.dart';
import 'package:life_bookshelf/services/home/autobiography_service.dart';
import 'package:life_bookshelf/services/chat-n/autobiography_service.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    const String baseUrl = 'https://jsonplaceholder.typicode.com';
    // ParentViewModel is singleton
    Get.put(RootViewModel());

    // ChildViewModel is singleton
    Get.put(HomeViewModel(
        HomeChapterService(baseUrl), HomeAutobiographyService(baseUrl)));
    Get.put(ChatAutobiographyService());
    Get.put(AutobiographyViewModel(ChatAutobiographyService()));

    Get.put(MypageViewModel());
    Get.put(PublishViewModel());
    Get.put(ChattingViewModel());
  }
}
