import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/views/chatting/chatting_screen.dart';
import 'package:life_bookshelf/views/home/home_screen.dart';
import 'package:life_bookshelf/views/login/login_screen.dart';
import 'package:life_bookshelf/views/mypage/mypage_screen.dart';
import 'package:life_bookshelf/views/onboarding/onboarding_screen.dart';
import 'package:life_bookshelf/views/publish/publish_screen.dart';
import 'package:life_bookshelf/views/root/custom_bottom_navigation_bar.dart';
import '../../viewModels/root/root_viewmodel.dart';
import '../base/base_screen.dart';
import '../../utilities/color_system.dart';

class RootScreen extends BaseScreen<RootViewModel> {

  const RootScreen({super.key});

  @override
  Color? get screenBackgroundColor => ColorSystem.screen.background;

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => IndexedStack(
        index: viewModel.selectedIndex,
        children: const [
          HomeScreen(),
          PublishScreen(),
          MypageScreen(),
        ],
      ),
    );
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    return const CustomBottomNavigationBar();
  }

  @override
  Widget? get buildFloatingActionButton => Container(
        width: 70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: ColorSystem.bottomNavigation.floatingButtonShadow,
              offset: const Offset(0, 5),
            ),
          ],
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorSystem.bottomNavigation.floatingButton,
              ColorSystem.bottomNavigation.floatingButton,
              ColorSystem.bottomNavigation.floatingButton,
            ],
            stops: const [0, 0.5, 1],
          ),
        ),
        child: FloatingActionButton.large(
          onPressed: () {
            final controller = Get.find<RootViewModel>();
            controller.changeIndex(0);
          },
          elevation: 0,
          highlightElevation: 2,
          shape: const CircleBorder(),
          backgroundColor: Colors.transparent,
          splashColor: ColorSystem.mainBlue,
          child: SvgPicture.asset(
            'assets/icons/Home.svg',
            fit: BoxFit.scaleDown,
          ),
        ),
      );

  @override
  FloatingActionButtonLocation? get floatingActionButtonLocation => FloatingActionButtonLocation.centerDocked;

  @override
  bool get extendBodyBehindAppBar => true;

  @override
  Color? get unSafeAreaColor => ColorSystem.white;

  @override
  bool get setTopOuterSafeArea => false;
}
