import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/mypage/components/publication_progress.dart';

class MypageScreen extends BaseScreen<MypageViewModel> {
  const MypageScreen({super.key});
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFF7F7F7),
      leading: Padding(
        padding: const EdgeInsets.only(left: 27.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 16),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      title: Text(
        'Mypage',
        style: FontSystem.KR16_58SB.copyWith(color: Colors.black),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          _Profile(),
          PublicationProgress(),
        ],
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorSystem.deepBlue,
        borderRadius: BorderRadius.circular(13),
      ),
      width: Get.width * 0.89,
      height: 76,
      child: Padding(
        padding: const EdgeInsets.only(left: 23, top: 17, bottom: 17),
        child: Row(
          children:[
            SvgPicture.asset(
              'assets/icons/mypage/profile.svg',
              width: 42,
              height: 42,

            ),
            SizedBox(width: 13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '황현정',
                  style: FontSystem.KR16M.copyWith(color: Colors.white),
                ),
                Text(
                  '2001.02.24',
                  style: FontSystem.KR11M.copyWith(color: ColorSystem.white),
                ),
              ],
            ),
            SizedBox(width: Get.width * 0.45),
            SvgPicture.asset('assets/icons/mypage/pen.svg')
          ]
        ),
      ),
    );
  }
}

class _ProgressnApplication extends StatelessWidget {
  const _ProgressnApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicationProgress();
  }
}


