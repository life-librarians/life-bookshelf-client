import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/services/login/login_service.dart';
import 'package:life_bookshelf/services/chatting/chatting_service.dart';
import 'package:life_bookshelf/viewModels/chatting/chatting_viewmodel.dart';
import 'package:life_bookshelf/viewModels/chat-n/autobiography_viewmodel.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';
import 'package:life_bookshelf/viewModels/onboarding/onboarding_viewmodel.dart';
import 'package:life_bookshelf/viewModels/publish/publish_viewmodel.dart';
import 'package:life_bookshelf/viewModels/root/root_viewmodel.dart';
import 'package:life_bookshelf/views/chatting/chatting_screen.dart';
import 'package:life_bookshelf/services/home/chapter_service.dart';
import 'package:life_bookshelf/services/chat-n/autobiography_service.dart';
import '../services/register/register_service.dart';
import '../viewModels/login/login_viewmodel.dart';
import '../viewModels/register/register_viewmodel.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    String baseUrl = dotenv.env['API'] ?? "";
    // ParentViewModel is singleton
    Get.put(RootViewModel(), permanent: true);

    Get.lazyPut(() => LoginViewModel(LoginService()));
    Get.lazyPut(() => RegisterViewModel(RegisterService()));

    Get.put(HomeViewModel(HomeChapterService(baseUrl)));
    Get.put(ChatAutobiographyService());
    Get.put(AutobiographyViewModel(ChatAutobiographyService()));
    Get.put(ChattingService());

    Get.put(MypageViewModel());
    Get.put(PublishViewModel());
    Get.put(ChattingViewModel());
    Get.put(MypageViewModel());
  }
}
