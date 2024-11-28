import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utilities/font_system.dart';
import '../../../viewModels/chat-n/autobiography_viewmodel.dart';

// 수정하기 전 Top
class TopBuild extends StatelessWidget {
  TopBuild({super.key});
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
        const SizedBox(width: 12.43),
        Text(
          viewModel.autobiography.value!.title ?? "Detail Chapter",
          style: FontSystem.KR14_51SB.copyWith(color: Colors.black),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            // 버튼 클릭 시 동작 추가
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            minimumSize: const Size(103, 32),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Color(0xFFBCC5D8), width: 1),
            ),
          ),
          child: Text(
            '다시 채팅하기',
            style: FontSystem.KR12SB.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

// 수정하기 전 Image
class ImageBuild extends StatelessWidget {
  ImageBuild({super.key});
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    print("이미지 url: ${viewModel.autobiography.value!.coverImageUrl}");
    return Center(
      child: Image(
        image: NetworkImage(viewModel.autobiography.value!.coverImageUrl),
        height: 290.15,
        errorBuilder: (context, error, stackTrace) {
          // 이미지 로드 실패 시 대체 위젯
          // return const Text('이미지를 불러올 수 없습니다.', style: TextStyle(color: Colors.red));
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// 수정하기 전 Preview
class ContentPreviewBuild extends StatelessWidget {
  ContentPreviewBuild({super.key, required this.onFixPressed});
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();
  final VoidCallback onFixPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          viewModel.autobiography.value?.content != null && viewModel.autobiography.value!.content!.length > 15
              ? "${viewModel.autobiography.value!.content!.substring(0, 15)}..."
              : viewModel.autobiography.value?.content ?? "content preview",
          style: FontSystem.KR20_72SB.copyWith(color: const Color(0xFF192252)),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onFixPressed,
          child: Image.asset(
            'assets/images/detail-chapter-fixbutton.png',
            width: 35,
            height: 45,
          ),
        ),
      ],
    );
  }
}

// 수정하기 전 FirstContent
class FirstContentBuild extends StatelessWidget {
  FirstContentBuild({super.key});
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    // 전체 내용을 단락별로 분리
    final content = viewModel.autobiography.value!.content!;
    final paragraphs = content.split('\n\n');

    // 첫 단락 추출
    final firstParagraph = paragraphs.isNotEmpty ? paragraphs[0] : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstParagraph.substring(0, 1),
          style: const TextStyle(
            fontSize: 40,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              firstParagraph.substring(1),
              style: FontSystem.KR14_51M.copyWith(color: const Color(0xFF838999)),
            ),
          ),
        ),
      ],
    );
  }
}

// 수정하기 전 RestContent
class RestContentBuild extends StatelessWidget {
  RestContentBuild({super.key});
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    // 전체 내용을 단락별로 분리
    final content = viewModel.autobiography.value!.content!;
    final paragraphs = content.split('\n\n');

    // 첫 단락을 제외한 나머지 단락 추출
    final restParagraphs = paragraphs.skip(1).join('\n\n');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        restParagraphs,
        style: FontSystem.KR14_51M.copyWith(color: const Color(0xFF838999)),
      ),
    );
  }
}
