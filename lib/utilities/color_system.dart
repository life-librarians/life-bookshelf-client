import 'package:flutter/material.dart';

abstract class ColorSystem {
  static const _General general = _General();
  static const _Screen screen = _Screen();
  static const _BottomNavigation bottomNavigation = _BottomNavigation();
  static const _Chatting chatting = _Chatting();

  // 공통 색상
  static const Color white = Color(0xFFFFFFFF);
  static const Color mainBlue = Color(0xFF567AF3);
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
}

class _Screen {
  const _Screen();

  final Color background = const Color(0xFFF7F7F7);
}

class _BottomNavigation {
  const _BottomNavigation();

  final Color floatingButtonShadow = const Color(0xFFA1A1A1);
  final Color floatingButton = ColorSystem.mainBlue;
}
