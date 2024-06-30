import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/views/home/home_screen.dart';
import 'package:life_bookshelf/views/root/custom_bottom_navigation_bar.dart';

import '../../viewModels/root/root_viewmodel.dart';
import '../base/base_screen.dart';

class RootScreen extends BaseScreen<RootViewModel> {
  const RootScreen({super.key});

  @override
  Color? get screenBackgroundColor => Colors.white;

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => IndexedStack(
        index: viewModel.selectedIndex,
        children: const [
          HomeScreen(),
          HomeScreen(),
        ],
      ),
    );
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    return const CustomBottomNavigationBar();
  }
}
