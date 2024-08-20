import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/models/home/chapter.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/chatting/chatting_screen.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:life_bookshelf/views/onboarding/onboarding_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/userpreferences_service.dart';
import '../chat-n/autobiography_detail_chapter_screen.dart';
import '../login/login_screen.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return SingleChildScrollView(
          child: Column(
            children: [
              const _Header(),
              const SizedBox(height: 25),
              const _TopCurrentPage(),
              const SizedBox(height: 38),
              Column(
                children: viewModel.chapters.map((chapter) => _Chapter(chapter: chapter)).toList(),
              ),
            ],
          ),
        );
      }
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 25, top: 45, bottom: 28),
        width: Get.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("또 와주셔서 감사해요, 여행자님.", style: FontSystem.KR13SB.copyWith(color: const Color(0xFF848FAC))),
            Row(
              children: [
                Text("당신의 이야기가 궁금해요", style: FontSystem.KR21SB.copyWith(color: const Color(0xFF192252))),
                const SizedBox(width: 6),
                Image.asset("assets/icons/main/book.png"),
              ],
            ),
          ],
        ));
  }
}

class _TopCurrentPage extends StatelessWidget {
  const _TopCurrentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = Get.find<HomeViewModel>();
    final currentChapter = viewmodel.currentChapter.value;
    final currentSubChapter = currentChapter?.subChapters.isNotEmpty == true ? currentChapter!.subChapters.first : null;
    return GestureDetector(
      onTap: () {
        // if (currentSubChapter != null) {
        if (true) {
          print("현재 인터뷰로 이동");
          // TODO: 인터뷰 이동 네비게이션 수정
          Get.to(() => ChattingScreen(currentChapter: viewmodel.currentChapter.value!));
        }
      },
      child: Column(children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12.72), // 오른쪽 위 모서리
                topLeft: Radius.circular(12.72), // 왼쪽 위 모서리
                bottomRight: Radius.circular(12.72), // 오른쪽 아래 모서리
              ),
              child: Image.asset(
                "assets/icons/main/example.png",
                width: Get.width * 0.88,
                height: Get.height * 0.1,
                fit: BoxFit.cover,
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8.48), // 오른쪽 위 모서리
              ),
              child: Container(
                height: 35.0,
                color: const Color(0xFFE6E6E6).withOpacity(0.5),
                alignment: Alignment.centerLeft,
                width: Get.width * 0.74,
                child: Container(
                  margin: const EdgeInsets.only(left: 17),
                  child: Text(
                    "현재 진행하고있는 페이지",
                    style: FontSystem.KR13R.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.48),
                color: Colors.white,
              ),
              width: Get.width * 0.74,
              height: 39.0,
              child: Container(
                margin: const EdgeInsets.only(left: 17),
                child: Text(
                  viewmodel.currentChapter.value?.chapterName ?? "진행하고 있는 챕터가 없습니다",
                  style: FontSystem.KR16SB.copyWith(color: const Color(0xFF192252)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 25, top: 4.6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: const Color(0xFFFFFFFF),
              ),
              width: Get.width * 0.089,
              height: Get.width * 0.089,
              padding: const EdgeInsets.all(7),
              child: SvgPicture.asset("assets/icons/main/send.svg"),
            )
          ],
        ),
      ]),
    );
  }
}

class _Chapter extends StatelessWidget {
  final HomeChapter chapter;

  const _Chapter({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 25, top: 6),
            child: Text(chapter.chapterName, style: FontSystem.KR17SB.copyWith(color: const Color(0xFF192252)))),
        const SizedBox(height: 8),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 26, right: 12.5),
              child: Column(
                children: List.generate((chapter.subChapters.length ?? 0) * 2 - 1, (index) {
                  if ((chapter.subChapters.length ?? 0) == 1 && index == 0) {
                    return Container(
                      child: SvgPicture.asset("assets/icons/main/circle.svg"),
                    );
                  } else if (index.isEven) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: SvgPicture.asset("assets/icons/main/circle.svg"),
                    );
                  } else {
                    return SvgPicture.asset("assets/icons/main/line.svg");
                  }
                }),
              ),
            ),
            _ChapterBoxs(chapter: chapter),
          ],
        ),
      ],
    );
  }
}

class _ChapterBoxs extends StatelessWidget {
  final HomeChapter chapter;

  const _ChapterBoxs({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: (chapter.subChapters ?? []).map((subChapter) => _ChapterBox(subChapter: subChapter)).toList(),
    );
  }
}

class _ChapterBox extends StatelessWidget {
  final HomeChapter subChapter;

  const _ChapterBox({super.key, required this.subChapter});

  @override
  Widget build(BuildContext context) {
    final viewmodel = Get.find<HomeViewModel>();
    String timeAgo = viewmodel.getTimeAge(subChapter.chapterCreatedAt);

    return GestureDetector(
      onTap: () {
        // Todo: 연동 후에 주석 없애기. 일단은 임시로 1로 테스트 해서 연동했습니다!!!
        // Todo: 지금 이슈가 chapterId가 1,2,3,4 이런식으로 떠야하는데 3,4,6,7, 이런식으로 떠서 수정해야 합니당
        Get.to(() => AutobiographyDetailScreen(autobiographyId: subChapter.chapterId));
        // Get.to(() => AutobiographyDetailScreen(autobiographyId: 1));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 17),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7.78),
                bottomLeft: Radius.circular(7.78),
              ),
              child: Image.asset(
                "assets/icons/main/example.png", // 예시 이미지로 대체
                width: Get.width * 0.22,
                height: 86,
                fit: BoxFit.cover,
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(7.78),
                bottomRight: Radius.circular(7.78),
              ),
              child: Container(
                color: Colors.white,
                width: Get.width * 0.59,
                height: 84,
                child: Padding(
                  padding: const EdgeInsets.only(left: 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'chapter ${subChapter.chapterNumber}',
                        style: FontSystem.KR12SB.copyWith(color: const Color(0xFF848FAC)),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subChapter.chapterName,
                        style: FontSystem.KR14SB.copyWith(color: const Color(0xFF192252)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        timeAgo,
                        style: FontSystem.KR12L.copyWith(color: const Color(0xFF848FAC)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
