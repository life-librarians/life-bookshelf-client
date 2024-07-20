import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';

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
    final MypageViewModel viewmodel = Get.find<MypageViewModel>();  // ViewModel 인스턴스를 가져옵니다.

    // 상태에 따라 배경색, 텍스트 색상, SVG 파일을 결정합니다.
    Color backgroundColor;
    Color textColor1;
    Color textColor2;
    String svgAsset;

    if (viewmodel.publishingStatus == 'REQUESTED') {
      backgroundColor = ColorSystem.mainBlue;
      textColor1 = ColorSystem.white;
      textColor2 = ColorSystem.white;
      svgAsset = 'assets/icons/mypage/01_w.svg';
    } else if (viewmodel.publishingStatus == 'REQUEST_CONFIRMED' || viewmodel.publishingStatus == 'IN_PUBLISHING' || viewmodel.publishingStatus == 'PUBLISHED') {
      backgroundColor = Colors.white; // 배경색 하얀색 유지
      textColor1 = ColorSystem.mypage.fontBlack;
      textColor2 = ColorSystem.mypage.fontGray;
      svgAsset = 'assets/icons/mypage/check.svg'; // 체크 이미지 사용
    } else {
      backgroundColor = Colors.white;
      textColor1 = ColorSystem.mypage.fontGray;
      textColor2 = ColorSystem.mypage.fontGray;
      svgAsset = 'assets/icons/mypage/01.svg';
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.7),
        color: backgroundColor,
      ),
      child: Container(

        height: 57,
        margin: const EdgeInsets.only(left: 18.8),
        child: Row(
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 31.33,
              height: 31.33,
            ),
            const SizedBox(width: 12.53),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("출판 신청 완료", style: FontSystem.KR11M.copyWith(color: textColor1)),
                Text("자서전을 검토하고 있어요.", style: FontSystem.KR11M.copyWith(color: textColor2)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _PubInProgress extends StatelessWidget {
  const _PubInProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final MypageViewModel viewmodel = Get.find<MypageViewModel>();  // ViewModel 인스턴스를 가져옵니다.

    // 조건에 따라 스타일을 선택합니다.
    // final backgroundColor = viewmodel.publishingStatus == 'requested' ? Colors.white : ColorSystem.mainBlue;
    // final textColor = viewmodel.publishingStatus == 'requested' ? ColorSystem.mypage.fontGray : ColorSystem.white;
    // final svgAsset = viewmodel.publishingStatus == 'requested' ? 'assets/icons/mypage/02.svg' : 'assets/icons/mypage/02_w.svg';
    Color backgroundColor;
    Color textColor1;
    Color textColor2;
    String svgAsset;

    if (viewmodel.publishingStatus == 'REQUESTED' || viewmodel.publishingStatus == 'REJECTED') {
      backgroundColor = ColorSystem.white;
      textColor1 = ColorSystem.mypage.fontGray;
      textColor2 = ColorSystem.mypage.fontGray;
      svgAsset = 'assets/icons/mypage/02.svg';
    } else if (viewmodel.publishingStatus == 'REQUEST_CONFIRMED' ){
    backgroundColor = ColorSystem.mainBlue;
      textColor1 = ColorSystem.white;
      textColor2 = ColorSystem.white;
      svgAsset = 'assets/icons/mypage/02_w.svg'; // 체크 이미지 사용
    } else {
      backgroundColor = Colors.white;
      textColor1 = ColorSystem.mypage.fontBlack;
      textColor2 = ColorSystem.mypage.fontGray;
      svgAsset = 'assets/icons/mypage/check.svg';
    }


    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.7),
        color: backgroundColor,
      ),
      child: Container(
        height: 57,
        margin: const EdgeInsets.only(left: 18.8),
        child: Row(
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 31.33,
              height: 31.33,
            ),
            const SizedBox(width: 12.53),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("출판 진행 단계", style: FontSystem.KR11M.copyWith(color: textColor1)),
                Text("제출한 자서전을 출판하고있어요. 평균 5일 소요되어요.", style: FontSystem.KR11M.copyWith(color: textColor2)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _PubCompleted extends StatelessWidget {
  const _PubCompleted({super.key});


  @override
  Widget build(BuildContext context) {

    final viewmodel = Get.find<MypageViewModel>();
    Color backgroundColor;
    Color textColor1;
    Color textColor2;
    String svgAsset;

    if (viewmodel.publishingStatus == 'REQUESTED' || viewmodel.publishingStatus == 'REQUEST_CONFIRMED' || viewmodel.publishingStatus == 'REJECTED')  {
      backgroundColor = ColorSystem.white;
      textColor1 = ColorSystem.mypage.fontGray;
      textColor2 = ColorSystem.mypage.fontGray;
      svgAsset = 'assets/icons/mypage/03.svg';
    } else if (viewmodel.publishingStatus == 'IN_PUBLISHING' ){
      backgroundColor = ColorSystem.mainBlue; // 배경색 하얀색 유지
      textColor1 = ColorSystem.white;
      textColor2 = ColorSystem.white;
      svgAsset = 'assets/icons/mypage/03_w.svg'; // 체크 이미지 사용
    } else {
      backgroundColor = Colors.white;
      textColor1 = ColorSystem.mypage.fontBlack;
      textColor2 = ColorSystem.mypage.fontGray;
      svgAsset = 'assets/icons/mypage/check.svg';
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.7),
        color: backgroundColor,
      ),
      child: Container(
        height: 57,
        margin: const EdgeInsets.only(left: 18.8),
        child: Row(
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 31.33,
              height: 31.33,
            ),
            const SizedBox(width: 12.53),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("출판 완료", style: FontSystem.KR11M.copyWith(color: textColor1)),
                Text("출판이 완료되었어요. 일주일 이후 수령할수 있어요.", style: FontSystem.KR11M.copyWith(color: textColor2)),
              ],
            )
          ],
        ),
      ),
    );
  }
}