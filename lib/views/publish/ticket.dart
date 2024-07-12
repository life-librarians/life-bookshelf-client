import 'package:flutter/material.dart';

class TicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const double radius = 25;
    const double edgeRadius = radius + 10;
    const double edgeCoor = 75;

    final path = Path()
      ..moveTo(radius, 0) // 좌상단 시작
      ..lineTo(size.width - radius, 0) // 상단 직선
      ..arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      ) // 우상단 곡선

      ..lineTo(size.width, edgeCoor) // 우측 직선 1
      ..quadraticBezierTo(size.width - edgeRadius / 1.5, edgeCoor + edgeRadius / 2, size.width, edgeCoor + edgeRadius) // 우측 첫 홈
      ..lineTo(size.width, size.height - (edgeCoor + edgeRadius)) // 우측 직선 2
      ..quadraticBezierTo(size.width - edgeRadius / 1.5, size.height - (edgeCoor + edgeRadius / 2), size.width, size.height - edgeCoor) // 우측 둘째 홈
      ..lineTo(size.width, size.height - radius) // 우측 직선 3

      ..arcToPoint(
        Offset(size.width - radius, size.height),
        radius: const Radius.circular(radius),
      ) // 우하단 곡선
      ..lineTo(radius, size.height) // 좌하단 직선
      ..arcToPoint(
        Offset(0, size.height - radius),
        radius: const Radius.circular(radius),
      ) // 좌하단 곡선

      ..lineTo(0, size.height - edgeCoor) // 좌측 직선 3
      ..quadraticBezierTo(edgeRadius / 1.5, size.height - (edgeCoor + edgeRadius / 2), 0, size.height - (edgeCoor + edgeRadius)) // 좌측 둘째 홈
      ..lineTo(0, edgeCoor + edgeRadius) // 좌측 직선 2
      ..quadraticBezierTo(edgeRadius / 1.5, (edgeCoor + edgeRadius / 2), 0, edgeCoor) // 좌측 첫째 홈
      ..lineTo(0, radius) // 좌측 직선 1

      ..arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      ) // 좌상단 곡선
      ..close(); // 경로 닫기

    canvas.drawPath(path, paint);

    // 점선 그리기
    final dashedPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double dashWidth = 5, dashSpace = 5, startY1 = edgeCoor + edgeRadius / 2, startY2 = size.height - (edgeCoor + edgeRadius / 2);
    double startX = edgeRadius / 2;
    while (startX < size.width - (edgeRadius / 2)) {
      canvas.drawLine(Offset(startX, startY1), Offset(startX + dashWidth, startY1), dashedPaint);
      canvas.drawLine(Offset(startX, startY2), Offset(startX + dashWidth, startY2), dashedPaint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
