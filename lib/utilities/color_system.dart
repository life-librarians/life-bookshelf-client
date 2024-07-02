import 'package:flutter/material.dart';

abstract class ColorSystem {
  static const _General general = _General();
  static const _Screen screen = _Screen();
  static const _BottomNavigation bottomNavigation = _BottomNavigation();

  // 공통 색상
  static const Color white = Color(0xFFFFFFFF);
  static const Color mainBlue = Color(0xFF567AF3);
}

class _General {
  const _General();

  final Color white = ColorSystem.white;
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
