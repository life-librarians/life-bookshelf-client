import 'package:flutter/material.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/utilities/screen_utils.dart';

class ChatBubble extends StatelessWidget {
  final String message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.w),
      child: CustomPaint(
        painter: UserBubblePainter(),
        child: Container(
          padding: EdgeInsets.only(left: 20.w, top: 15.w, right: 20.w, bottom: 15.w),
          child: Text(
            message,
            style: FontSystem.KR16R.copyWith(color: ColorSystem.white),
          ),
        ),
      ),
    );
  }
}

class UserBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF6E8EFA)
      ..style = PaintingStyle.fill;
    const double radius = 12;
    double tailWidth = size.width * (1 / 10);
    double tailHeight = size.width * (1 / 20);
    final Path path = Path()
      ..moveTo(radius, 0) // 좌상단 코너 시작
      ..lineTo(size.width - radius, 0) // 상단 직선
      ..arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      ) // 우상단 코너
      ..lineTo(size.width, size.height) // 우측 직선
      ..cubicTo(size.width, size.height + tailHeight * 2, size.width - tailWidth, size.height, size.width - tailWidth * 2, size.height)
      // 3차 베지에 곡선을 통한 꼬리 구현
      ..lineTo(size.width - tailWidth, size.height) // 우하단 몸통으로 복귀
      ..lineTo(radius, size.height) // 좌하단 코너 시작지점으로 통하는 직선
      ..arcToPoint(
        Offset(0, size.height - radius),
        radius: const Radius.circular(radius),
      ) // 좌하단 코너
      ..lineTo(0, radius) // 좌측 직선
      ..arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      ) // 다시 좌상단 코너로
      ..close(); // 경로 닫기

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
