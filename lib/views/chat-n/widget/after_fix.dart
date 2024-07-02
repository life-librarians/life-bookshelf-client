import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utilities/font_system.dart';
import '../../../viewModels/chat-N/autobiography_viewmodel.dart';

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
          onPressed: () {
            // 버튼 클릭 시 동작 추가
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
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
        GestureDetector(
          onTap: () {
            viewModel.toggleEditing();
            if (viewModel.isEditing.value) {
              viewModel.contentController.text = viewModel.autobiography.value!.content ?? '';
            }
          },
          child: Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: viewModel.isEditing.value
                  ? TextField(
                controller: viewModel.contentController,
                style: FontSystem.KR14_51M.copyWith(color: Color(0xFF838999)),
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              )
                  : Text(
                viewModel.autobiography.value!.content ?? "No content",
                style: FontSystem.KR14_51M.copyWith(color: Color(0xFF838999)),
                textAlign: TextAlign.start,
              ),
            );
          }),
        ),
      ],
    );
  }
}