import 'package:get/get.dart';
import 'package:life_bookshelf/views/chat-N/autobiography_detail_chapter_screen.dart';
import 'package:life_bookshelf/views/chatting/chatting_screen.dart';
import 'package:life_bookshelf/views/onboarding/onboarding_screen.dart';
import '../bindings/root_binding.dart';
import '../views/home/home_screen.dart';
import '../views/root/root_screen.dart';
import 'app_routes.dart';

List<GetPage> appPages = [
  GetPage(
    name: Routes.ROOT,
    page: () => const RootScreen(),
    binding: RootBinding(),
  ),
  GetPage(
    name: Routes.HOME,
    page: () => const HomeScreen(),
    binding: RootBinding(),
  ),
  GetPage(
    name: Routes.AUTOBIOGRAPHY_DETAIL_CHAPTER,
    page: () => const AutobiographyDetailScreen(
      autobiographyId: 0,
    ),
    binding: RootBinding(),
  ),
  GetPage(
    name: Routes.CHATTING,
    // TODO: get.argumentsfh ㅊ
    page: () => ChattingScreen(
      currentChapter: Get.arguments['currentChapter'],
      // currentAutobiographies: Get.arguments['currentAutobiographies'],
    ),
    binding: RootBinding(),
  ),
  GetPage(
    name: Routes.ONBOARDING,
    page: () => const OnboardingScreen(),
    binding: RootBinding(),
  )
];
