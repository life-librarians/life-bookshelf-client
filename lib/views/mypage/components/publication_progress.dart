import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("출판 진행 상황", style: FontSystem.KR14B.copyWith(color: ColorSystem.mypage.fontBlack)),
          SizedBox(height: 10),
          Container(
            width: Get.width * 0.89,
            height: 173,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFCFD6DC), // Hex 색상 코드
                width: 1,
                style: BorderStyle.solid, // 'solid' 테두리 스타일
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                _pubAppSubmitted(),
                _PubInProgress(),
                _PubCompleted(),
              ],
            ),
          )

        ],
      ),
    );
  }
}

class _pubAppSubmitted extends StatelessWidget {
  const _pubAppSubmitted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 18.8),
      height: 57,
      child: Row(
        children:[
          SvgPicture.asset(
            'assets/icons/mypage/check.svg',
            width: 31.33,
            height: 31.33,
          ),
          SizedBox(width: 12.53),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("출판 신청 완료", style: FontSystem.KR11M.copyWith(color: ColorSystem.mypage.fontBlack)),
              Text("자서전을 검토하고 있어요.", style: FontSystem.KR11M.copyWith(color: ColorSystem.mypage.fontGray)),
            ],
          )
        ]
      ),
    );
  }
}

class _PubInProgress extends StatelessWidget {
  const _PubInProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.7),
        color: ColorSystem.mainBlue,
      ),
      height: 57,
      child: Container(
        margin: const EdgeInsets.only(left: 18.8),
        child: Row(
            children:[
              SvgPicture.asset(
                'assets/icons/mypage/02_w.svg',
                width: 31.33,
                height: 31.33,
              ),
              SizedBox(width: 12.53),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("출판 진행 단계", style: FontSystem.KR11M.copyWith(color: ColorSystem.white)),
                  Text("제출한 자서전을 출판하고있어요. 평균 5일 소요되어요.", style: FontSystem.KR11M.copyWith(color: ColorSystem.white)),
                ],
              )
            ]
        ),
      ),
    );
  }
}

class _PubCompleted extends StatelessWidget {
  const _PubCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 18.8 ),
      height: 57,
      child: Row(
          children:[
            SvgPicture.asset(
              'assets/icons/mypage/03.svg',
              width: 31.33,
              height: 31.33,
            ),
            SizedBox(width: 12.53),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("출판 완료", style: FontSystem.KR11M.copyWith(color: ColorSystem.mypage.fontGray)),
                Text("출판이 완료되었어요. 일주일 이후 수령할수 있어요.", style: FontSystem.KR11M.copyWith(color: ColorSystem.mypage.fontGray)),
              ],
            )
          ]
      ),
    );
  }
}



