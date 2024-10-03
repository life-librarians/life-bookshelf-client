import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:life_bookshelf/main_app.dart';
import 'package:life_bookshelf/services/image_upload_service.dart';
import 'package:life_bookshelf/services/userpreferences_service.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/viewModels/onboarding/onboarding_viewmodel.dart';
import 'package:life_bookshelf/viewModels/root/root_viewmodel.dart';

void main() async {
  await dotenv.load(fileName: "assets/config/.env");
  await initializeDateFormatting();
  await UserPreferences.init();

  Get.put(OnboardingViewModel());
  Get.put(RootViewModel());
  Get.put(ImageUploadService());

  final OnboardingViewModel viewmodel = Get.find<OnboardingViewModel>();
  final onboardingCompleted = await viewmodel.isOnboardingCompleted();
  viewmodel.clearOnboardingStatus();

  final mainApp = MainApp(initialRoute: "/", onboardingCompleted: onboardingCompleted);

  if (kIsWeb) {
    runApp(WebLayoutWrapper(child: mainApp));
  } else {
    runApp(mainApp);
  }
}

class WebLayoutWrapper extends StatelessWidget {
  final Widget child;

  const WebLayoutWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          body: Stack(
            children: [
              // Background pattern
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/web/background_pattern.png',
                  ),
                ),
              ),

              // Left side content
              Positioned(
                left: 152,
                top: 46,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with "Powered by" text and logo
                    Row(
                      children: [
                        Text(
                          "Powered by 이분의 일",
                          style: FontSystem.KR13B.copyWith(color: Color(0xFF4F5E71))
                        ),
                        SizedBox(width: 0),
                        Image.asset('assets/web/2_1_icon.png', height: 25),
                      ],
                    ),
                    SizedBox(height: 133),

                    // Memoir Architect with logo
                    Row(
                      children: [
                        Image.asset('assets/web/planet_icon.png', height: 21),
                        SizedBox(width: 10),
                        Text(
                          "M E M O I R  A R C H I T E C T",
                          style: FontSystem.KR22M.copyWith(color: Color(0xFF697D95)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Main headings
                    Text(
                      "내 이야기를 담는",
                      style: FontSystem.KR67B,
                    ),
                    Text(
                      "가장 편한 커뮤니티",
                      style: FontSystem.KR67B,
                    ),
                    SizedBox(height: 20),

                    // Subheadings
                    Text(
                      "정리하기 힘들었던 나만의 이야기",
                      style: FontSystem.KR25M.copyWith(color: Color(0xFF4F5E71)),
                    ),
                    Text(
                      "인생책장에서 편하고, 빠르게 적어나가요.",
                      style: FontSystem.KR25M.copyWith(color: Color(0xFF4F5E71)),
                    ),
                    SizedBox(height: 40),

                    // Buttons
                    Row(
                      children: [
                        Container(
                          width: 258,
                          height: 59,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF00A991),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // Google Play Store link
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/web/play_icon.png', height: 45),
                                SizedBox(width: 5),
                                Text('Google Play', style: FontSystem.KR24B.copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 24),
                        Container(
                          width: 258,
                          height: 59,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF00A991),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // App Store link
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/web/apple_icon.png', height: 45),
                                SizedBox(width: 5),
                                Text('App Store', style: FontSystem.KR24B.copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),

              // Right side with phone frame
              Positioned(
                right: 80,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // App content
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 310,
                          height: 660,
                          child: child,
                        ),
                      ),
                      // Phone frame image
                      IgnorePointer(
                        child: Image.asset(
                          'assets/web/iphone-blank.png',
                          width: 350,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Text('이미지 로드 실패');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Return the original app for mobile devices
      return child;
    }
  }
}