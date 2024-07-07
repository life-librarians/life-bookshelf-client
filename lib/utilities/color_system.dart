import 'package:flutter/material.dart';

abstract class ColorSystem {
  static const _General general = _General();
  static const _Screen screen = _Screen();
  static const _BottomNavigation bottomNavigation = _BottomNavigation();
  static const _Mypage mypage = _Mypage();

  // 공통 색상
  static const Color white = Color(0xFFFFFFFF);
  static const Color mainBlue = Color(0xFF567AF3);
  static const Color deepBlue = Color(0xFF0601B4);
}

class _General {
  const _General();

  final Color white = ColorSystem.white;
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
