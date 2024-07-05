import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/utilities/screen_utils.dart';
import 'package:life_bookshelf/viewModels/chatting/chatting_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/chatting/chatBubble.dart';

class ChattingScreen extends BaseScreen<ChattingViewModel> {
  const ChattingScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          chattingHeader(),
          const ChatBubble(isUser: true, message: "그 중에서도 가장 기억에 남는 순간은 내 생일 파티였어. 여름이었고, 엄마가 느티나무 아래에서 작은 파티를 준비해 주셨어."),
          const ChatBubble(isUser: false, message: "그 중에서도 가장 기억에 남는 순간은 내 생일 파티였어. 여름이었고, 엄마가 느티나무 아래에서 작은 파티를 준비해 주셨어."),
          const ChatBubble(isUser: true, message: "어쩌라고"),
          const ChatBubble(isUser: false, message: ". . ."),
          const ChatBubble(isUser: true, message: ""),
        ],
      ).paddingSymmetric(horizontal: 15),
    );
  }

  Widget chattingHeader() {
    return SizedBox(
      height: 80.h,
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Interview Chat", style: FontSystem.KR18SB),
                Text("65% completed", style: FontSystem.KR10M.copyWith(color: Colors.black.withOpacity(0.5))),
                const ProgressBar(progress: 65).paddingSymmetric(vertical: 3)
              ],
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({super.key, required this.progress});

  final double barWidth = 220;
  final double barHeight = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: barWidth,
      height: barHeight,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Container(
            width: barWidth * (progress / 100),
            height: barHeight,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
