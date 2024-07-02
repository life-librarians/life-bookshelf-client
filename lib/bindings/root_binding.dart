import 'package:get/get.dart';
import 'package:life_bookshelf/viewModels/chat-N/autobiography_viewmodel.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';
import 'package:life_bookshelf/viewModels/publish/publish_viewmodel.dart';
import 'package:life_bookshelf/viewModels/root/root_viewmodel.dart';

import '../services/chat-N/autobiography_service.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    // ParentViewModel is singleton
    Get.put(RootViewModel());

    // ChildViewModel is singleton
    Get.put(HomeViewModel());
    Get.put(AutobiographyViewModel(AutobiographyService()));

    Get.put(MypageViewModel());
    Get.put(PublishViewModel());
  }
}
