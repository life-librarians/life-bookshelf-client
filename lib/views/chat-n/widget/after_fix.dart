import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/app_routes.dart';
import '../../../utilities/font_system.dart';
import '../../../viewModels/chat-n/autobiography_viewmodel.dart';

// 수정 후 Top
class TopAfterFixBuild extends StatelessWidget {
  TopAfterFixBuild({Key? key}) : super(key: key);
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/icons/detail-chapter.png',
          width: 33.16,
          height: 33.16,
        ),
        SizedBox(width: 12.43),
        Text(
          viewModel.autobiography.value!.title ?? "Detail Chapter",
          style: FontSystem.KR14_51SB.copyWith(color: Colors.black),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () async {
            // Todo: 연동하기
            await viewModel.submitCorrections();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF567AF3), // 버튼 색상 설정
            minimumSize: Size(103, 32),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Color(0xFF567AF3), width: 1),
            ),
          ),
          child: Text(
            '교정교열 완료',
            style: FontSystem.KR12SB.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// 수정 후 TopHelp
class TopAfterFixHelpBuild extends StatelessWidget {
  TopAfterFixHelpBuild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "누르면 다시 원래 텍스트로 변합니다.",
      style: FontSystem.KR12R.copyWith(color: Color(0xFF7B7B7B)),
    );
  }
}

// 수정 후 Content
class AfterFixContentBuild extends StatelessWidget {
  AfterFixContentBuild({Key? key}) : super(key: key);
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 텍스트',
          style: FontSystem.KR15R.copyWith(color: Colors.black),
        ),
        Obx(() {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: RichText(
              text: TextSpan(
                children: _buildTextSpans(viewModel),
              ),
            ),
          );
        }),
      ],
    );
  }

  List<TextSpan> _buildTextSpans(AutobiographyViewModel viewModel) {
    List<TextSpan> spans = [];
    String content = viewModel.contentController.text;
    List<Map<String, String>> corrections = viewModel.textCorrections;

    int lastIndex = 0;

    for (int i = 0; i < corrections.length; i++) {
      String original = corrections[i]["original"]!;
      String corrected = corrections[i]["corrected"]!;

      int index = content.indexOf(corrected, lastIndex);

      if (index != -1) {
        if (lastIndex != index) {
          spans.add(TextSpan(
            text: content.substring(lastIndex, index),
            style: FontSystem.KR14_51M.copyWith(color: Color(0xFF838999)),
          ));
        }

        spans.add(TextSpan(
          text: viewModel.correctionStates[i] == true ? corrected : original,
          style: FontSystem.KR14_51M.copyWith(
            color: viewModel.correctionStates[i] == true ? Colors.green : Colors.red,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              viewModel.toggleCorrectionState(i);
            },
        ));
        lastIndex = index + corrected.length;
      } else {
        print("No match found for '$corrected' in the content.");
      }
    }
    if (lastIndex < content.length) {
      spans.add(TextSpan(
        text: content.substring(lastIndex),
        style: FontSystem.KR14_51M.copyWith(color: Color(0xFF838999)),
      ));
    }
    return spans;
  }
}