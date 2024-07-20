import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/viewModels/onboarding/onboarding_viewmodel.dart';

class NameField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  NameField({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel viewModel = Get.find<OnboardingViewModel>();

    _controller.addListener(() {
      viewModel.updateAnswer(_controller.text);
      viewModel.validateName(_controller.text);
    });
    return Container(
      width: Get.width * 0.83,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 33),
          Obx(() => Container(
              height: Get.height * 0.056,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter your name",
                hintStyle: TextStyle(color: Color(0xFFD5D4DC,
                ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: viewModel.isNameValid.value || viewModel.isButtonPressed.value == false ? Color(0xFFD5D4DC) : Colors.red,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: viewModel.isNameValid.value ? ColorSystem.mainBlue : Colors.red,
                    width: 1,
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
