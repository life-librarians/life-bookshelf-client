import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/views/chatting/chatting_screen.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Home"),
          CupertinoButton(
            child: const Text("go to Chatting View"),
            onPressed: () {
              Get.to(() => const ChattingScreen());
            },
          ),
        ],
      ),
    );
  }
}
