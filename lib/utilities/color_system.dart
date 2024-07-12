import 'package:flutter/material.dart';

abstract class ColorSystem {
  static const _General general = _General();
  static const _Screen screen = _Screen();
  static const _BottomNavigation bottomNavigation = _BottomNavigation();
  static const _Mypage mypage = _Mypage();
  static const _Chatting chatting = _Chatting();

  // 공통 색상
  static const Color white = Color(0xFFFFFFFF);
  static const Color mainBlue = Color(0xFF567AF3);
  static const Color deepBlue = Color(0xFF0601B4);
  static const Color accentBlue = Color(0xFF2B4BF2);
}

class _General {
  const _General();

  final Color white = ColorSystem.white;
  final Color mainBlue = ColorSystem.mainBlue;
}

class _Chatting {
  const _Chatting();

  final Color bubbleBackground1 = const Color(0xFFD8D8D8);
  final Color bubbleBackground2 = ColorSystem.mainBlue;
  final Color chatColor1 = const Color(0xFF585763);
  final Color chatColor2 = ColorSystem.white;
  final Color timeStamp = const Color(0xFF848395);
  final Color modalContentColor = const Color(0x80151920); // 0x151920, opacity 50%
  final Color modalButtonColor1 = const Color(0x42566789); // 0x566789, opacity 26%
}

class _Screen {
  const _Screen();
  final Color background = const Color(0xFFF7F7F7);
  final Color green = const Color(0xFF428929);
  final Color red = const Color(0xFFAD4949);
}

class _BottomNavigation {
  const _BottomNavigation();

  final Color floatingButtonShadow = const Color(0xFFA1A1A1);
  final Color floatingButton = ColorSystem.mainBlue;
}

class _Mypage {
  const _Mypage();

  final Color fontBlack = const Color(0xFF181D27);
  final Color fontGray = const Color(0xFFABB7C2);
}
