import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/views/home/home_screen.dart';
import 'package:life_bookshelf/views/mypage/mypage_screen.dart';
import 'package:life_bookshelf/views/publish/publish_screen.dart';
import 'package:life_bookshelf/views/root/custom_bottom_navigation_bar.dart';

import '../../viewModels/root/root_viewmodel.dart';
import '../base/base_screen.dart';

class RootScreen extends BaseScreen<RootViewModel> {
  const RootScreen({super.key});

  @override
  Color? get screenBackgroundColor => Color(0xFFF7F7F7);

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
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(
          blurRadius: 6,
          color: Color(0xFFA1A1A1),
          offset: Offset(0, 5),
        ),
      ],
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF567AF3),
          Color(0xFF567AF3),
          Color(0xFF567AF3),
        ],
        stops: [0, 0.5, 1],
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
      splashColor: const Color(0xFF567AF3),
      child: SvgPicture.asset(
        'assets/icons/Home.svg',
        fit: BoxFit.scaleDown,
      ),
    ),
  );

  @override
  FloatingActionButtonLocation? get floatingActionButtonLocation =>
      FloatingActionButtonLocation.centerDocked;

  @override
  bool get extendBodyBehindAppBar => true;

  @override
  Color? get unSafeAreaColor => const Color(0xFFFFFFFF);

  @override
  bool get setTopOuterSafeArea => false;
}
