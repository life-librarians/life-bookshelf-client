import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: CustomPaint(
        painter: UserBubblePainter(),
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16),
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
    const double tailWidth = 30;
    const double tailHeight = 15;
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
