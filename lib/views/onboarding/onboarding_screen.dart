import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/viewModels/onboarding/onboarding_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';

import 'package:life_bookshelf/views/onboarding/components/cloud_window.dart';
import 'package:life_bookshelf/views/onboarding/components/disk_button.dart';
import 'package:life_bookshelf/views/onboarding/components/name_field.dart';

class OnboardingScreen extends BaseScreen<OnboardingViewModel> {
  const OnboardingScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    final viewmodel = Get.find<OnboardingViewModel>();
    viewmodel.updateCurrentQuestion();
    return Column(
      children: [
        SizedBox(height: Get.height * 0.10),
        CloudWindow(),
        SizedBox(
          height: 27.0,
        ),
        _Dots(),
        SizedBox(
          height: 12.0,
        ),
        _QuestionTexts(),
        _BottomItems(),
      ],
    );
  }

  @override
  Color? get screenBackgroundColor => Color(0xFFF7F6FB);
}


class _BottomItems extends StatelessWidget {
  const _BottomItems({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel viewmodel = Get.find<OnboardingViewModel>();

    // Wrapping the switch statement inside Obx() to make it reactive
    return Obx(() {
      switch (viewmodel.currentQuestionIndex.value) {
        case 0:
          return Column(
            children: [
              NameField(),
              SizedBox(
                height: Get.height * 0.10,
              ),
              DiskButton(
                onPressed: () {
                  viewmodel.addCurrentQuestionIndex();
                  viewmodel.updateCurrentQuestion();
                },
                text: 'Next',
              ),
            ],
          ); // Replace with your actual widget for index 0
        case 1:
          return Column(); // Replace with your actual widget for index 1
        case 2:
          return Column(); // Replace with your actual widget for index 2
        case 3:
          return Column(); // Replace with your actual widget for index 3
        default:
          return SizedBox(height: 0); // Default case for handling undefined indexes
      }
    });
  }
}

class _Dots extends StatelessWidget {
  const _Dots({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel viewModel = Get.find<OnboardingViewModel>();

    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) => buildDot(index, viewModel)),
    ));
  }

  Widget buildDot(int index, OnboardingViewModel viewModel) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: 12.0,
      height: 12.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: viewModel.currentQuestionIndex.value == index ? Color(0xFF2A94F4) : Color(0xFFD3D3D3),
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

    return Obx(() => Container(
      width: Get.width * 0.83,
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              viewmodel.currentQuestion.value,
              key: ValueKey<String>(viewmodel.currentQuestion.value), // Key based on current question
              style: FontSystem.KR24B.copyWith(
                color: ColorSystem.onboarding.fontBlack,
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                viewmodel.currentQuestionDetail.value,
                key: ValueKey<String>(viewmodel.currentQuestionDetail.value), // Key based on current detail
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