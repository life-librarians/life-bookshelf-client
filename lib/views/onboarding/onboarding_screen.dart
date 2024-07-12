
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/viewModels/onboarding/onboarding_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';

import 'package:life_bookshelf/views/onboarding/components/cloud_window.dart';
class OnboardingScreen extends BaseScreen<OnboardingViewModel> {
  const OnboardingScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Get.height * 0.10),
        CloudWindow(),
        SizedBox(height: 27.0,),
        _Dots(),
        SizedBox(height: 12.0,),
        _QuestionTexts(),
      ],
    );
  }


}

class _Dots extends StatelessWidget {
  const _Dots({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = Get.find<OnboardingViewModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          viewmodel.currentQuestionIndex.value == 0
              ? 'assets/icons/onboarding/dot_blue.svg'
              : 'assets/icons/onboarding/dot_gray.svg',
        ),
        SizedBox(width: 8.0,),
        SvgPicture.asset(
          viewmodel.currentQuestionIndex.value == 1
              ? 'assets/icons/onboarding/dot_blue.svg'
              : 'assets/icons/onboarding/dot_gray.svg',
        ),
        SizedBox(width: 8.0,),
        SvgPicture.asset(
          viewmodel.currentQuestionIndex.value == 2
              ? 'assets/icons/onboarding/dot_blue.svg'
              : 'assets/icons/onboarding/dot_gray.svg',
        ),
        SizedBox(width: 8.0,),
        SvgPicture.asset(
          viewmodel.currentQuestionIndex.value == 3
              ? 'assets/icons/onboarding/dot_blue.svg'
              : 'assets/icons/onboarding/dot_gray.svg',)
      ],
    );
  }
}

class _QuestionTexts extends StatelessWidget {
  const _QuestionTexts({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = Get.find<OnboardingViewModel>();
    return Column(

      children: [
        Text(viewmodel.questions[viewmodel.currentQuestionIndex.value],
          style: FontSystem.KR24B.copyWith(
            color: ColorSystem.onboarding.fontBlack,
          ),
        ),
        SizedBox(height: 15.0,),
        Container(
          alignment: Alignment.center,
          width: Get.width * 0.75,
          child: Text(viewmodel.questionsDetails[viewmodel.currentQuestionIndex.value],
            style: FontSystem.KR17M.copyWith(
              color: ColorSystem.onboarding.fontGray,

            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
