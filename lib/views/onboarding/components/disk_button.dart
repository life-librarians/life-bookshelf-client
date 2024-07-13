import 'package:flutter/material.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';

class DiskButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const DiskButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.91, // Set the width to 91% of the screen width
      height: 67, // Set the fixed height
      decoration: BoxDecoration(
        color: Colors.white, // Set background color to white
        borderRadius: BorderRadius.circular(1100),
        border: Border.all(
          color: Colors.black.withOpacity(0.1), // Set border color to black with 10% opacity
          width: 1, // Set border width
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          splashColor: ColorSystem.mainBlue.withOpacity(0.1), // Customizable splash color
          highlightColor: Colors.blue.withOpacity(0.1), // Customizable highlight color
          borderRadius: BorderRadius.circular(8), // Match the border radius
          child: Center(
            child: Text(
              text,
              style: FontSystem.KR20M.copyWith(
                color: ColorSystem.onboarding.fontBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
