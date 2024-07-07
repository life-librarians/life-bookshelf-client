import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:life_bookshelf/utilities/color_system.dart';

import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';

class SimpleToggleSwitch extends StatelessWidget {
  final int index;

  SimpleToggleSwitch({required this.index});

  @override
  Widget build(BuildContext context) {
    final MypageViewModel toggleController = Get.find();

    return Obx(() => FlutterSwitch(
      activeColor: ColorSystem.mainBlue,
      inactiveColor: Color(0xFFE8E8E8),
      toggleColor: Color(0xFFABABAB),
      activeToggleColor: Colors.white,
      width: 51,
      height: 30,
      toggleSize: 20,
      value: toggleController.switches[index].value,
      onToggle: (value) {
        toggleController.toggleSwitch(index, value);
      },
    ));
  }
}
