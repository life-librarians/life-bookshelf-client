import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/models/home/autobiography.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/utilities/screen_utils.dart';
import 'package:life_bookshelf/viewModels/chatting/chatting_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/chatting/chatBubble.dart';

class ChattingScreen extends BaseScreen<ChattingViewModel> {
  final int? currentChapterId;
  final List<HomeAutobiography>? currentAutobiographies;

  const ChattingScreen({super.key, required this.currentChapterId, required this.currentAutobiographies});

  @override
  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              chattingHeader(),
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ChatBubble(isUser: true, message: "그 중에서도 가장 기억에 남는 순간은 내 생일 파티였어. 여름이었고, 엄마가 느티나무 아래에서 작은 파티를 준비해 주셨어."),
                      ChatBubble(isUser: false, message: "그 중에서도 가장 기억에 남는 순간은 내 생일 파티였어. 여름이었고, 엄마가 느티나무 아래에서 작은 파티를 준비해 주셨어."),
                      ChatBubble(isUser: true, message: "그 중에서도 가장 기억에 남는 순간은 내 생일 파티였어. 여름이었고, 엄마가 느티나무 아래에서 작은 파티를 준비해 주셨어."),
                      ChatBubble(isUser: false, message: "그 중에서도 가장 기억에 남는 순간은 내 생일 파티였어. 여름이었고, 엄마가 느티나무 아래에서 작은 파티를 준비해 주셨어."),
                      ChatBubble(isUser: true, message: "어쩌라고"),
                      ChatBubble(isUser: false, message: ". . ."),
                      ChatBubble(isUser: false, message: ". . ."),
                      ChatBubble(isUser: false, message: ". . ."),
                      ChatBubble(isUser: true, message: ""),
                    ],
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 15),
        ),
        Obx(() => MicButton(
              micState: viewModel.micState,
              buttonFunction: viewModel.changeMicState,
            )),
      ],
    );
  }

  /// Chatting Screen Header
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

class MicButton extends StatelessWidget {
  final MicState micState;
  final VoidCallback buttonFunction;

  const MicButton({
    super.key,
    required this.micState,
    required this.buttonFunction,
  });

  @override
  Widget build(BuildContext context) {
    IconData buttonIcon;
    Color buttonColor;

    switch (micState) {
      case MicState.ready:
        buttonIcon = CupertinoIcons.mic_fill;
        buttonColor = ColorSystem.mainBlue;
        break;
      case MicState.inProgress:
        buttonIcon = CupertinoIcons.stop_fill;
        buttonColor = CupertinoColors.systemRed;
        break;
      case MicState.finish:
        buttonIcon = CupertinoIcons.checkmark_alt;
        buttonColor = CupertinoColors.systemGreen;
        break;
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 20, // 화면 하단에서의 거리
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: buttonColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CupertinoButton(
            onPressed: buttonFunction,
            padding: EdgeInsets.zero,
            child: Icon(
              buttonIcon,
              color: ColorSystem.white,
              size: (micState == MicState.finish) ? 55 : 40,
            ),
          ),
        ),
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
