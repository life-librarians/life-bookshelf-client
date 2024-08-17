import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utilities/font_system.dart';
import '../../../viewModels/chat-n/autobiography_viewmodel.dart';

// 수정 중인 Top
class TopFixBuild extends StatelessWidget {
  TopFixBuild({Key? key, required this.onFixPressed}) : super(key: key);
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();
  final VoidCallback onFixPressed;

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
            onFixPressed();
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
            '수정 완료',
            style: FontSystem.KR12SB.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// 수정 중인 TopHelp
class TopHelpBuild extends StatelessWidget {
  TopHelpBuild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "최대한 주제에 어긋나지 않는 한에서 수정 해주신 뒤, 수정완료를 눌러주세요. 교정 교열은 저희가 도와드려요.",
      style: FontSystem.KR12R.copyWith(color: Color(0xFF7B7B7B)),
    );
  }
}

// 수정 중인 Content
class FixContentBuild extends StatelessWidget {
  FixContentBuild({Key? key}) : super(key: key);
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          viewModel.autobiography.value?.content != null && viewModel.autobiography.value!.content!.length > 15
              ? viewModel.autobiography.value!.content!.substring(0, 15) + "..."
              : viewModel.autobiography.value?.content ?? "content preview",
          style: FontSystem.KR20_72SB.copyWith(color: Color(0xFF192252)),
        ),
        SizedBox(height: 13),
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