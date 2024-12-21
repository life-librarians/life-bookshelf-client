import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/models/home/autobiography.dart';
import 'package:life_bookshelf/models/home/chapter.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/utilities/screen_utils.dart';
import 'package:life_bookshelf/viewModels/chatting/chatting_viewmodel.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';

class ChattingScreen extends BaseScreen<ChattingViewModel> {
  final HomeChapter? currentChapter;

  const ChattingScreen({super.key, required this.currentChapter});

  @override
  void initViewModel() {
    super.initViewModel();
    // TODO: Null Checking
    viewModel.loadConversations(currentChapter!);
    print('Chatting Screen Initialized: currentChapterId: ${currentChapter!.chapterId}');

    debounce(
      viewModel.isInterviewFinished,
      (finished) {
        if (finished) {
          viewModel.isInterviewFinished.value = false;
          _showFinishModal();
          // viewModel.isLoading.value = false;
        }
      },
      time: const Duration(milliseconds: 3000),
    );
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
          // 마이크 버튼
          MicButton(
            micState: viewModel.micState,
            buttonFunction: viewModel.changeMicState,
          ),
          // 더미 프롬프트 버튼
          // Positioned(
          //   right: 40,
          //   bottom: 40,
          //   child: Container(
          //     width: 40,
          //     height: 40,
          //     decoration: BoxDecoration(
          //       color: ColorSystem.mainBlue,
          //       shape: BoxShape.circle,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.2),
          //           spreadRadius: 0,
          //           blurRadius: 10,
          //           offset: const Offset(0, 3),
          //         ),
          //       ],
          //     ),
          //     child: CupertinoButton(
          //       onPressed: () => viewModel.sendDummyPrompt(),
          //       padding: EdgeInsets.zero,
          //       child: const Icon(
          //         CupertinoIcons.add,
          //         color: ColorSystem.white,
          //         size: 20,
          //       ),
          //     ),
          //   ),
          // ),
          // 로딩 인디케이터와 반투명 배경
          if (viewModel.isLoading.value)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {}, // 터치 이벤트를 막기 위해 빈 onTap 사용
                child: Container(
                  color: Colors.black.withOpacity(0.2), // 반투명 회색 배경
                  child: const Center(
                    child: CupertinoActivityIndicator(radius: 20),
                  ),
                ),
              ),
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
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Interview Chat", style: FontSystem.KR18SB),
                // TODO: 진행도 수정 필요
                // TODO: 삭제한 코드들 복원 필요
                // Text("65% completed", style: FontSystem.KR10M.copyWith(color: Colors.black.withOpacity(0.5))),
                // const ProgressBar(progress: 65).paddingSymmetric(vertical: 3)
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     // TODO: 임시 버튼. 추후 수정 바람.
          //     _showFinishModal();
          //   },
          //   child: Container(width: 30, color: ColorSystem.mainBlue),
          // ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }

  void _showFinishModal() {
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            '인터뷰가 완료되었어요.',
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
                    fixedSize: Size.fromHeight(42.h),
                  ),
                  child: Text('없어요', style: FontSystem.KR14SB.copyWith(color: ColorSystem.chatting.modalContentColor)),
                  onPressed: () async {
                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false, // 화면 터치 방지
                    );

                    await viewModel.finishInterview();

                    // 챕터 정보 갱신
                    final homeViewModel = Get.find<HomeViewModel>();
                    await homeViewModel.fetchAllData();

                    navigateBackWithDelay();
                  },
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
                    fixedSize: Size.fromHeight(42.h),
                  ),
                  child: Text('첨부할래요', style: FontSystem.KR14SB.copyWith(color: ColorSystem.white)),
                  onPressed: () async {
                    await viewModel.pickImage();
                    if (viewModel.selectedImage.value != null) {
                      Get.back();
                      _showImageConfirmationModal(viewModel);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TODO: 이미지 첨부 확인 모달창 디자인 확정 or 제거
  void _showImageConfirmationModal(ChattingViewModel viewModel) {
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            '선택한 사진',
            style: FontSystem.KR20B,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(viewModel.selectedImage.value!),
            const SizedBox(height: 20),
            const Text('이 사진을 사용하시겠습니까?', style: FontSystem.KR13SB),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('다시 선택', style: FontSystem.KR14SB),
            onPressed: () async {
              viewModel.clearSelectedImage();
              await viewModel.pickImage();
              if (viewModel.selectedImage.value != null) {
                Get.back();
                _showImageConfirmationModal(viewModel);
              }
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorSystem.white,
              backgroundColor: ColorSystem.accentBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              // 로딩 다이얼로그 표시
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(),
                ),
                barrierDismissible: false, // 화면 터치 방지
              );

              await viewModel.finishInterview();

              // 챕터 정보 갱신
              final homeViewModel = Get.find<HomeViewModel>();
              await homeViewModel.fetchAllData();

              navigateBackWithDelay();
            },
            child: Text('확인', style: FontSystem.KR14SB.copyWith(color: ColorSystem.white)),
          ),
        ],
      ),
    );
  }

  Future<void> navigateBackWithDelay() async {
    Get.back(); // 로딩 다이얼로그 닫기
    await Future.delayed(const Duration(milliseconds: 100));
    Get.back(); // 이전 화면으로 돌아가기
    await Future.delayed(const Duration(milliseconds: 100));
    Get.back();
    Get.dialog(
      const Center(
        child: CupertinoActivityIndicator(radius: 20), // iOS 스타일 로딩 프로그레스 서클
      ),
      barrierDismissible: false, // 화면 터치 방지
    );
    await Future.delayed(const Duration(seconds: 5)); // 5초 대기
    Get.back(); // 로딩 다이얼로그 닫기
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
      bottom: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
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
