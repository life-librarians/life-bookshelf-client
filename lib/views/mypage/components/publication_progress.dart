import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';


class PublicationProgress extends StatelessWidget {
  const PublicationProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      width: Get.width * 0.89,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Text("출판 진행 상황", style: FontSystem.KR14B.copyWith(color: ColorSystem.mypage.fontBlack)),
        ],
      ),
    );
  }
}


class _ProgressnApplication extends StatelessWidget {
  const _ProgressnApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



class _ProgressInProgress extends StatelessWidget {
  const _ProgressInProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class _ProgressDone extends StatelessWidget {
  const _ProgressDone({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}