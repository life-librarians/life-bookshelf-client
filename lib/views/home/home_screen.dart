import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _Header(),
          _TopCurrentPage(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25,top: 45, bottom: 28),
      width: Get.width,
      color: Colors.white,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("또 와주셔서 감사해요, 여행자님.",
          style: FontSystem.KR13SB.copyWith(color: Color(0xFF848FAC))),
          Row(
            children: [
              Text("당신의 이야기가 궁금해요",
              style: FontSystem.KR21SB.copyWith(color: Color(0xFF192252))),
              SizedBox(width: 6),
              Image.asset("assets/icons/main/book.png"),
            ],
          ),

        ],
      )
    );
  }
}

class _TopCurrentPage extends StatelessWidget {
  const _TopCurrentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children : [
        Stack(
        alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.72), // 오른쪽 위 모서리
                topLeft: Radius.circular(12.72),  // 왼쪽 위 모서리
                bottomRight: Radius.circular(12.72), // 오른쪽 아래 모서리
              ),
              child: Image.asset("assets/icons/main/example.png",
              width: Get.width * 0.88,
              height: Get.height * 0.1,
              fit: BoxFit.cover,),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.48), // 오른쪽 위 모서리
              ),
              child: Container(
                height: 35.0,
                color: Color(0xFFE6E6E6).withOpacity(0.5),
                alignment: Alignment.centerLeft,
                width: Get.width * 0.74,
                child: Container(
                  margin: EdgeInsets.only(left: 17),
                  child: Text("현재 진행하고있는 페이지",
                    style: FontSystem.KR13R.copyWith(color: Colors.white),),
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
              margin: EdgeInsets.only(left: 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.48),
                color: Colors.white,
              ),
              width: Get.width * 0.74,
              height: 39.0,
              child: Container(
                margin: EdgeInsets.only(left: 17),
                child: Text("20살 이후, 그때의 나는",
                style: FontSystem.KR16SB.copyWith(color: Color(0xFF192252)),),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 25, top: 4.6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xFFFFFFFF),
              ),
              width: Get.width * 0.089,
              height: Get.width * 0.089,
              padding: EdgeInsets.all(7),
              child: SvgPicture.asset("assets/icons/main/send.svg"),
            )
          ],
        )
      ]
    );
  }
}
