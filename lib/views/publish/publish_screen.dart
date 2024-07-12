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
    return Center(
      child: CustomPaint(
        painter: TicketPainter(),
        child: Container(
          width: 333,
          height: 400,
          padding: const EdgeInsets.all(20),
          child: _ticketContent(),
        ),
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
                child: Container(height: 1, color: Colors.grey),
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
