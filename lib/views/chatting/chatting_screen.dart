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

class ChattingScreen extends BaseScreen<ChattingViewModel> {
  final int? currentChapterId;
  final List<HomeAutobiography>? currentAutobiographies;

  const ChattingScreen({super.key, required this.currentChapterId, required this.currentAutobiographies});

  @override
  void initViewModel() {
    super.initViewModel();
    // TODO: Null Checking
    viewModel.loadConversations(currentChapterId!);
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                chattingHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [...viewModel.chatBubbles, const SizedBox(height: 100)],
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 15),
          ),
          MicButton(
            micState: viewModel.micState,
            buttonFunction: viewModel.changeMicState,
          ),
        ],
      ),
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
          GestureDetector(
            onTap: () {
              // TODO: 임시 버튼. 추후 수정 바람.
              _showFinishModal();
            },
            child: Container(width: 30, color: ColorSystem.mainBlue),
          ),
        ],
      ),
    );
  }

  void _showFinishModal() {
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            '인터뷰가 완료되었어요',
            style: FontSystem.KR20B,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            '이 인터뷰와 관련한, 혹은 이 연령대에 관련한 사진이 있나요? 있다면 사진을 첨부해주세요. 없다면 자서전에 사진이 실리지 않아요.',
            style: FontSystem.KR13R.copyWith(color: ColorSystem.chatting.modalContentColor),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: ColorSystem.chatting.modalContentColor,
                    backgroundColor: ColorSystem.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: ColorSystem.chatting.modalButtonColor1, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    fixedSize: const Size.fromHeight(42),
                  ),
                  child: Text('없어요', style: FontSystem.KR14SB.copyWith(color: ColorSystem.chatting.modalContentColor)),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorSystem.white,
                    backgroundColor: ColorSystem.accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    fixedSize: const Size.fromHeight(42),
                  ),
                  child: Text('첨부할래요', style: FontSystem.KR14SB.copyWith(color: ColorSystem.white)),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
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
