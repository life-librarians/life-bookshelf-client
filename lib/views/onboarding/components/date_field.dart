import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/viewModels/onboarding/onboarding_viewmodel.dart';

class DateField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  DateField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<OnboardingViewModel>();

    void showCupertinoDatePicker() {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 300,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              _controller.text = newDate.toString().split(' ')[0]; // Format the date as YYYY-MM-DD
              viewModel.updateAnswer(_controller.text);
              viewModel.validateDate();// Update the ViewModel
            },
          ),
        ),
      );
    }

    return Obx(() => Container(
      width: Get.width * 0.83,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.038),
          GestureDetector(
            onTap: showCupertinoDatePicker,
            child: AbsorbPointer(
              child: Container(
                  height: Get.height * 0.056,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "생년월일을 입력하기 위해 터치",
                    hintStyle: TextStyle(color: viewModel.isDateValid.value || viewModel.isButtonPressed.value == false? ColorSystem.onboarding.fontGray : Colors.red),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: viewModel.isDateValid.value || viewModel.isButtonPressed.value == false? Color(0xFFD5D4DC) : Colors.red,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: viewModel.isDateValid.value ? ColorSystem.mainBlue : Colors.red,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

}
