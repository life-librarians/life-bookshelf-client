import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/viewModels/root/root_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_widget.dart';

class CustomBottomNavigationBar extends BaseWidget<RootViewModel> {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(
          () => Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: 18.0,
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 75,
            color: const Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildBottomNavigationBarItem(
                  index: 1,
                  size: 30,
                  svgPath: 'assets/icons/publish.svg',
                  text: "출판페이지",
                ),
                const SizedBox(width: 70),
                _buildBottomNavigationBarItem(
                  index: 2,
                  size: 30,
                  svgPath: 'assets/icons/Profile.svg',
                  text: "마이페이지",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem({
    required int index,
    required double size,
    required String svgPath,
    required String text,
  }) =>
      Expanded(
        child: InkWell(
          onTap: () => viewModel.changeIndex(index),
          child: Column(
            children: [
              SvgPicture.asset(
                svgPath,
                width: size,
                colorFilter: viewModel.selectedIndex == index
                    ? const ColorFilter.mode(
                    Color(0xFF567AF3), BlendMode.srcATop)
                    : const ColorFilter.mode(
                    Color(0xFF67686D), BlendMode.srcATop),
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: viewModel.selectedIndex == index
                      ? const Color(0xFF567AF3)
                      : const Color(0xFF67686D),
                ),
              ),
            ],
          ),
        ),
      );
}
