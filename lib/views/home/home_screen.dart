import 'package:flutter/material.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:get/get.dart';
import '../../utilities/app_routes.dart';
import 'autobiography-detail-chapter_screen.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Home"),
          ElevatedButton(
            onPressed: () {
              Get.to(AutobiographyDetailScreen(autobiographyId: 0));
            },
            child: const Text("임시 디테일 챕터 페이지로 이동"),
          ),
        ],
      ),
    );
  }
}



