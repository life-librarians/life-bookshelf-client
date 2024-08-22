import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_bookshelf/models/home/chapter.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/chatting/chatting_screen.dart';
import 'package:life_bookshelf/views/chat-n/autobiography_detail_chapter_screen.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return RefreshIndicator(
          onRefresh: viewModel.fetchAllData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _Header(),
                const SizedBox(height: 25),
                _TopCurrentPage(),
                const SizedBox(height: 38),
                Obx(() => Column(
                  children: viewModel.chapters.map((chapter) => _Chapter(chapter: chapter)).toList(),
                )),
              ],
            ),
          ),
        );
      }
    });
  }
}

class _Header extends GetView<HomeViewModel> {
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
      ),
    );
  }
}

class _TopCurrentPage extends GetView<HomeViewModel> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentChapter = controller.currentChapter.value;
      final currentSubChapter = currentChapter?.subChapters.isNotEmpty == true ? currentChapter!.subChapters.first : null;

      return GestureDetector(
        onTap: () {
          if (currentChapter != null) {
            Get.to(() => ChattingScreen(currentChapter: currentChapter));
          }
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12.72),
                    topLeft: Radius.circular(12.72),
                    bottomRight: Radius.circular(12.72),
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
                    topRight: Radius.circular(8.48),
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
                      currentChapter?.chapterName ?? "진행하고 있는 챕터가 없습니다",
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
          ],
        ),
      );
    });
  }
}

class _Chapter extends GetView<HomeViewModel> {
  final HomeChapter chapter;

  const _Chapter({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 6),
          child: Text(chapter.chapterName, style: FontSystem.KR17SB.copyWith(color: const Color(0xFF192252))),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 26, right: 12.5),
              child: Column(
                children: List.generate((chapter.subChapters.length) * 2 - 1, (index) {
                  if (chapter.subChapters.length == 1 && index == 0) {
                    return SvgPicture.asset("assets/icons/main/circle.svg");
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

class _ChapterBoxs extends GetView<HomeViewModel> {
  final HomeChapter chapter;

  const _ChapterBoxs({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: chapter.subChapters.map((subChapter) => _ChapterBox(subChapter: subChapter)).toList(),
    );
  }
}

class _ChapterBox extends GetView<HomeViewModel> {
  final HomeChapter subChapter;

  const _ChapterBox({super.key, required this.subChapter});

  @override
  Widget build(BuildContext context) {
    String timeAgo = controller.getTimeAge(subChapter.chapterCreatedAt);

    List<String> chapterParts = subChapter.chapterNumber.split('.');
    int majorPart = int.parse(chapterParts[0]);
    int minorPart = chapterParts.length > 1 ? int.parse(chapterParts[1]) : 0;

    final List<String> images = [
      "assets/icons/main/example1.png",
      "assets/icons/main/example2.png",
      "assets/icons/main/example3.png",
    ];
    int imageIndex = ((majorPart - 1) * 2 + (minorPart - 1)) % images.length;

    return GestureDetector(
      onTap: () {
        Get.to(() => AutobiographyDetailScreen(autobiographyId: subChapter.chapterId));
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
                images[imageIndex],
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
                        'chapter $majorPart.$minorPart',
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