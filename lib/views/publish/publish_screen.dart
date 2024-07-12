import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/viewModels/publish/publish_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/publish/ticket.dart';

class PublishScreen extends BaseScreen<PublishViewModel> {
  const PublishScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            _bookOption(),
            CustomPaint(
              painter: TicketPainter(),
              child: Container(
                width: 333,
                height: 400,
                padding: const EdgeInsets.all(20),
                child: _ticketContent(),
              ),
            ),
            const SizedBox(height: 22),
            _publicationButton()
          ],
        ),
      ),
    );
  }

  Container _bookOption() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 이미지 부분
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image, size: 40, color: Colors.grey),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '표지에 넣을 이미지',
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // 오른쪽 텍스트 부분
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('책 제목', style: FontSystem.KR16SB.copyWith(color: ColorSystem.publication.optionTitle)),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '제목을 입력하세요',
                      hintStyle: FontSystem.KR14R.copyWith(color: ColorSystem.publication.titleLocationButton),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: FontSystem.KR14SB.copyWith(color: ColorSystem.publication.optionTitle),
                  ),
                ),
                const SizedBox(height: 16),
                Text('제목 위치', style: FontSystem.KR16SB.copyWith(color: ColorSystem.publication.optionTitle)),
                const SizedBox(height: 10),
                Row(
                  children: ['상단', '중간', '하단', '왼쪽']
                      .map((text) => Container(
                            margin: const EdgeInsets.only(right: 11),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // 버튼 탭 동작 추가
                                },
                                borderRadius: BorderRadius.circular(5),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  child: Text(text, style: FontSystem.KR12SB.copyWith(color: ColorSystem.publication.titleLocationButton)),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _publicationButton() {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          // TODO: 출판 진행 로직 구현
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: ColorSystem.mainBlue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text("이대로 출판 진행하기", style: FontSystem.KR18SB.copyWith(color: Colors.white)),
      ),
    );
  }

  Column _ticketContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('황현정', style: FontSystem.KR16SB),
        Text('도로위의 무법자', style: FontSystem.KR12SB.copyWith(color: ColorSystem.publication.ticketContentGray80)),
        const SizedBox(height: 65),
        _flightRow(),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoBox(Icons.calendar_today, "Date", "March 24, 2024"),
            const SizedBox(width: 10), // 박스 사이의 간격
            _infoBox(Icons.access_time, "Time", "1 month, 1 hour"),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bookDetailRow("페이지", "123p"),
            _bookDetailRow("예상시간", "20일"),
            _bookDetailRow("가격", "30,000원"),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Row _bookDetailRow(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: FontSystem.KR12SB.copyWith(color: ColorSystem.publication.ticketContentGray60)),
        const SizedBox(width: 8),
        Text(content, style: FontSystem.KR14SB.copyWith(color: ColorSystem.publication.ticketContentGray80)),
      ],
    );
  }

  Row _flightRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('2024.02.24', style: FontSystem.KR12SB.copyWith(color: ColorSystem.publication.ticketContentGray30)),
            Text('첫 비행', style: FontSystem.KR16SB.copyWith(color: ColorSystem.publication.ticketContentGray80)),
            Text('0페이지', style: FontSystem.KR12SB.copyWith(color: ColorSystem.publication.ticketContentGray60)),
          ],
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 회색의 긴 선
              Positioned(
                left: 5,
                right: 5,
                child: Container(height: 1.5, color: Colors.grey),
              ),
              // 원형 배경과 비행기 아이콘
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flight_takeoff, size: 24, color: Colors.white),
              ),
              // 오른쪽 끝의 화살표
              const Positioned(
                right: 0,
                child: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('2024.03.24', style: FontSystem.KR12SB.copyWith(color: ColorSystem.publication.ticketContentGray30)),
            Text('출판', style: FontSystem.KR16SB.copyWith(color: ColorSystem.publication.ticketContentGray80)),
            Text('123페이지', style: FontSystem.KR12SB.copyWith(color: ColorSystem.publication.ticketContentGray60)),
          ],
        ),
      ],
    );
  }
}

Widget _infoBox(IconData icon, String title, String content) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorSystem.publication.ticketContentBlue10, // 연한 파란색 배경
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: ColorSystem.publication.ticketContentBlue),
              const SizedBox(width: 4),
              Text(
                title,
                style: FontSystem.KR10SB.copyWith(color: ColorSystem.publication.ticketContentBlue60),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: FontSystem.KR14SB.copyWith(color: ColorSystem.publication.ticketContentBlue),
          ),
        ],
      ),
    ),
  );
}
