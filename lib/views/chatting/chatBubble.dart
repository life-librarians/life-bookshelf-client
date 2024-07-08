import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/utilities/screen_utils.dart';

class ChatBubble extends StatelessWidget {
  final bool isUser;
  final String message;
  final bool isFinal;

  const ChatBubble({
    super.key,
    required this.isUser,
    required this.message,
    this.isFinal = false,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets margin;
    CustomPainter painter;
    Color textColor;
    CrossAxisAlignment timeStampAlignment;

    if (isUser) {
      margin = EdgeInsets.only(left: 90.w);
      painter = UserBubblePainter();
      textColor = ColorSystem.chatting.chatColor2;
      timeStampAlignment = CrossAxisAlignment.end;
    } else {
      margin = EdgeInsets.only(right: 90.w);
      painter = InterviewerBubblePainter();
      textColor = ColorSystem.chatting.chatColor1;
      timeStampAlignment = CrossAxisAlignment.start;
    }

    final timeStampMargin = calculateTimestampMargin(message, FontSystem.KR16R.copyWith(color: textColor));

    return Container(
      margin: margin,
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: timeStampAlignment,
        children: [
          Opacity(
            opacity: isFinal ? 1.0 : 0.7, // 인식 진행 중 opacity
            child: CustomPaint(
              painter: painter,
              child: Container(
                padding: EdgeInsets.only(left: 20.w, top: 15.w, right: 20.w, bottom: 15.w),
                child: Text(
                  message,
                  style: FontSystem.KR16R.copyWith(color: textColor),
                ),
              ),
            ),
          ),
          // TODO: TimeStamp 실제 값 수정
          if (!isFinal) ...[
            Container(
              margin: EdgeInsets.only(top: timeStampMargin),
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(ColorSystem.chatting.chatColor1),
              ),
            )
          ] else ...[
            Container(
              margin: EdgeInsets.only(top: timeStampMargin),
              child: Text(
                "01:30 PM",
                style: FontSystem.KR14SB.copyWith(color: ColorSystem.chatting.timeStamp),
              ),
            )
          ]
        ],
      ),
    );
  }

  /// message text의 길이를 이용하여 chatBubble의 width를 계산, 이후 timestamp와 chatBubble 사이의 margin 값을 계산합니다.
  double calculateTimestampMargin(String message, TextStyle textStyle) {
    final textSpan = TextSpan(
      text: message,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    final messageWidth = textPainter.size.width;

    // 패딩을 포함한 버블의 실제 너비 계산
    final finalWidth = messageWidth + 40.w;

    // 최종 margin값 계산 (20과 계산된 값 중 작은 값을 사용)
    return min(20.h, finalWidth / 10);
  }
}

class UserBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = ColorSystem.chatting.bubbleBackground2
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

class InterviewerBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = ColorSystem.chatting.bubbleBackground1
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
      ..lineTo(size.width, size.height - radius) // 우측 직선
      ..arcToPoint(
        Offset(size.width - radius, size.height),
        radius: const Radius.circular(radius),
      ) // 우하단 코너
      ..lineTo(tailWidth * 2, size.height) // 하단 직선
      ..cubicTo(tailWidth, size.height, 0, size.height + tailHeight * 2, 0, size.height)
      // 3차 베지에 곡선을 통한 꼬리 구현
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
