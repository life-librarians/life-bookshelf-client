import 'package:flutter/material.dart';

class ScreenUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double refHeight;
  static late double refWidth;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    refHeight = 852; // 참조 기기의 높이
    refWidth = 393; // 참조 기기의 너비

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
  }

  /// 주어진 높이 값을 현재 화면 크기에 맞게 비례적으로 조정합니다.
  ///
  /// [height]는 참조 디바이스의 높이값(refHeight)을 기준으로 한 원래의 높이 값입니다.
  ///
  /// 반환값은 현재 화면 크기에 맞게 조정된 높이 값입니다.
  ///
  /// 예: ScreenUtils.height(100)은 참조 디바이스에서 100px 높이가
  /// 현재 디바이스에서 어떤 높이로 표시되어야 하는지 계산합니다.
  static double height(double height) {
    double screenHeight = ScreenUtils.screenHeight;
    return (height / refHeight) * screenHeight;
  }

  /// 주어진 너비 값을 현재 화면 크기에 맞게 비례적으로 조정합니다.
  ///
  /// [width]는 참조 디바이스 너비값(refWidth)을 기준으로 한 원래의 너비 값입니다.
  ///
  /// 반환값은 현재 화면 크기에 맞게 조정된 너비 값입니다.
  ///
  /// 예: ScreenUtils.width(200)은 참조 디바이스에서 200px 너비가
  /// 현재 디바이스에서 어떤 너비로 표시되어야 하는지 계산합니다.
  static double width(double width) {
    double screenWidth = ScreenUtils.screenWidth;
    return (width / refWidth) * screenWidth;
  }

  /// 주어진 폰트 크기를 현재 화면 너비에 맞게 비례적으로 조정합니다.
  ///
  /// [size]는 참조 디바이스를 기준으로 한 원래의 폰트 크기입니다.
  ///
  /// 반환값은 현재 화면 크기에 맞게 조정된 폰트 크기입니다.
  ///
  /// 이 메서드는 내부적으로 [width] 메서드를 사용하여 크기를 조정합니다.
  ///
  /// 예: ScreenUtils.fontSize(16)은 참조 디바이스에서 16px 폰트 크기가
  /// 현재 디바이스에서 어떤 크기로 표시되어야 하는지 계산합니다.
  static double fontSize(double size) {
    return width(size);
  }
}

/// num type에 화면 크기 조정 기능을 추가하는 Extension입니다.
extension ScreenUtilsExtension on num {
  /// 높이값을 현재 화면 크기에 맞게 비례적으로 조정합니다.
  ///
  /// 예시:
  /// ```dart
  /// double adjustedHeight = 100.h;
  /// ```
  double get h => (this / ScreenUtils.refHeight) * ScreenUtils.screenHeight;

  /// 너비값을 현재 화면 크기에 맞게 비례적으로 조정합니다.
  /// 예시:
  /// ```dart
  /// double adjustedWidth = 200.w;
  /// ```
  double get w => (this / ScreenUtils.refWidth) * ScreenUtils.screenWidth;
}
