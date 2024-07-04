import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/viewModels/chatting/chatting_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/chatting/chatBubble.dart';

class ChattingScreen extends BaseScreen<ChattingViewModel> {
  const ChattingScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Chatting"),
          ChatBubble(isUser: true, message: "그 중에서도 가장 기억에 남는 순간은 내 생일 파티였어. 여름이었고, 엄마가 느티나무 아래에서 작은 파티를 준비해 주셨어."),
          ChatBubble(isUser: false, message: "그 중에서도 가장 기억에 남는 순간은 내 생일 파티였어. 여름이었고, 엄마가 느티나무 아래에서 작은 파티를 준비해 주셨어."),
        ],
      ),
    );
  }
}
