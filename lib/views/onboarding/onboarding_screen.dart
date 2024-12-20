import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/viewModels/onboarding/onboarding_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/onboarding/components/cloud_window.dart';
import 'package:life_bookshelf/views/onboarding/components/date_field.dart';
import 'package:life_bookshelf/views/onboarding/components/disk_button.dart';
import 'package:life_bookshelf/views/onboarding/components/name_field.dart';

class OnboardingScreen extends BaseScreen<OnboardingViewModel> {
  const OnboardingScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    viewModel.updateCurrentQuestion();
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면 리사이즈
      body: Stack(
        children: [
          SingleChildScrollView(
            // 키보드가 올라올 때 자동으로 스크롤되도록
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.05),
                const CloudWindow(),
                SizedBox(height: Get.height * 0.031),
                const _Dots(),
                SizedBox(height: Get.height * 0.012),
                const _QuestionTexts(),
                const _BottomItems(),
                // 키보드 높이만큼 추가 공간 확보
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Color? get screenBackgroundColor => const Color(0xFFF7F6FB);
}

class _BottomItems extends StatelessWidget {
  const _BottomItems({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel viewmodel = Get.find<OnboardingViewModel>();
    return Obx(() {
      switch (viewmodel.currentQuestionIndex.value) {
        case 0:
          return Column(
            children: [
              NameField(),
              SizedBox(height: Get.height * 0.10),
              DiskButton(
                onPressed: () {
                  if (viewmodel.isNameValid.value == false) return;
                  viewmodel.nextQuestion();
                },
                text: 'Next',
              ),
            ],
          );
        case 1:
          return Column(
            children: [
              DateField(),
              SizedBox(height: Get.height * 0.10),
              DiskButton(
                onPressed: () {
                  if (viewmodel.isDateValid.value == false) return;
                  viewmodel.nextQuestion();
                },
                text: 'Next',
              ),
            ],
          );
        case 2:
          return Column(
            children: [
              SizedBox(height: Get.height * 0.05),
              DiskButton(
                  onPressed: () {
                    viewmodel.updateAnswer("MALE");
                    viewmodel.nextQuestion();
                  },
                  text: "남자"),
              const SizedBox(height: 20),
              DiskButton(
                  onPressed: () {
                    viewmodel.updateAnswer("FEMALE");
                    viewmodel.nextQuestion();
                  },
                  text: "여자"),
            ],
          );
        case 3:
          return Column(
            children: [
              SizedBox(height: Get.height * 0.05),
              DiskButton(
                  onPressed: () {
                    viewmodel.updateAnswer("true");
                    viewmodel.nextQuestion();
                  },
                  text: "있어"),
              const SizedBox(height: 20),
              DiskButton(
                  onPressed: () {
                    viewmodel.updateAnswer("false");
                    viewmodel.nextQuestion();
                  },
                  text: "없어"),
            ],
          );
        case 4:
          return Column(
            children: [
              NameField(hintText: "직업을 입력해주세요"),
              SizedBox(height: Get.height * 0.10),
              DiskButton(
                onPressed: () {
                  if (viewmodel.isNameValid.value == false) return;
                  viewmodel.nextQuestion();
                },
                text: 'Next',
              ),
            ],
          );
        case 5:
          return Column(
            children: [
              NameField(hintText: "학력을 입력해주세요"),
              SizedBox(height: Get.height * 0.10),
              DiskButton(
                onPressed: () {
                  if (viewmodel.isNameValid.value == false) return;
                  viewmodel.nextQuestion();
                },
                text: 'Next',
              ),
            ],
          );
        case 6:
          return Column(
            children: [
              SizedBox(height: Get.height * 0.05),
              DiskButton(
                  onPressed: () {
                    viewmodel.updateAnswer("true");
                    viewmodel.nextQuestion();
                  },
                  text: "네"),
              const SizedBox(height: 20),
              DiskButton(
                  onPressed: () {
                    viewmodel.updateAnswer("false");
                    viewmodel.nextQuestion();
                  },
                  text: "아니오"),
            ],
          );
        case 7:
          viewmodel.updateUserInformation();
          return Image.asset(
            "assets/images/AirplaneLoading.gif",
            width: 250,
          );
        default:
          return const SizedBox(height: 0);
      }
    });
  }
}

class _Dots extends StatelessWidget {
  const _Dots({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel viewModel = Get.find<OnboardingViewModel>();

    return Obx(() => viewModel.currentQuestionIndex <= 6
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) => buildDot(index, viewModel)),
          )
        : const SizedBox());
  }

  Widget buildDot(int index, OnboardingViewModel viewModel) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 12.0,
      height: 12.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: viewModel.currentQuestionIndex.value == index ? const Color(0xFF2A94F4) : const Color(0xFFD3D3D3),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _QuestionTexts extends StatelessWidget {
  const _QuestionTexts({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel viewmodel = Get.find<OnboardingViewModel>();

    return Obx(() => SizedBox(
          width: Get.width * 0.83,
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  viewmodel.currentQuestion.value,
                  key: ValueKey<String>(viewmodel.currentQuestion.value),
                  style: FontSystem.KR24B.copyWith(
                    color: ColorSystem.onboarding.fontBlack,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.017),
              Container(
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Text(
                    viewmodel.currentQuestionDetail.value,
                    key: ValueKey<String>(viewmodel.currentQuestionDetail.value),
                    style: FontSystem.KR17M.copyWith(
                      color: ColorSystem.onboarding.fontGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
