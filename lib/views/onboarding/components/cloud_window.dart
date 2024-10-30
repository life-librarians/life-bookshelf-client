import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';

class CloudWindow extends StatelessWidget {
  const CloudWindow({super.key});

  @override
  Widget build(BuildContext context) {
    String text = "Powered by GIPHY";
    double width = MediaQuery.of(context).size.width * 0.58;
    double height = MediaQuery.of(context).size.height * 0.35;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/cloud_1.png',
          width: width,
          height: height,
          fit: BoxFit.contain,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: text
              .split('')
              .map((letter) => Text(
            letter,
            style: FontSystem.KR15EL.copyWith(
              height: 0.9,
              color: ColorSystem.onboarding.fontGray,
            ),
          ))
              .toList(),
        ),
      ],
    );
  }
}
