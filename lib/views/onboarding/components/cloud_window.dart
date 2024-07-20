import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';

class CloudWindow extends StatelessWidget {
  const CloudWindow({super.key});

  @override
  Widget build(BuildContext context) {
    String text = "Powered by GIPHY";
    double width = MediaQuery.of(context).size.width *
        0.58;
    double height = MediaQuery.of(context).size.height *
        0.35;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<img.Image?>(
          future: loadAnimatedWebP('assets/images/cloud_1.webp', width.toInt(), height.toInt()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final image = snapshot.data!;
              final pngBytes = img.encodePng(image);
              return Center(
                child: Image.memory(Uint8List.fromList(pngBytes)),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Failed to load image: ${snapshot.error}"),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Use min to reduce extra space
          children: text
              .split('')
              .map((letter) => Text(
                    letter,
                    style: FontSystem.KR15EL.copyWith(
                        height: 0.9,
                      color: ColorSystem.onboarding.fontGray,
                    ), // Reduce line height for closer spacing
                  ))
              .toList(),
        ),
      ],
    );
  }
}

Future<img.Image?> loadAnimatedWebP(String path, int width, int height) async {
  try {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    var image = img.decodeWebP(bytes);
    if (image != null) {
      // Resize the image to dynamic width and 305 pixels height
      image = img.copyResize(image, width: width, height: height);
    }
    return image;
  } catch (e) {
    print('Error loading WebP: $e');
    return null;
  }
}

