import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:life_bookshelf/main_app.dart';
import 'package:life_bookshelf/services/image_upload_service.dart';
import 'package:life_bookshelf/services/userpreferences_service.dart';
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
          body: Stack(
            children: [
              // Background
              Container(
                color: Colors.grey[200], // 배경색 설정
              ),

              // Centered phone frame with app content
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    // App content
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20), // 앱 콘텐츠의 모서리를 둥글게
                      child: Container(
                        width: 310, // 앱 콘텐츠 너비 (프레임보다 작게)
                        height: 660, // 앱 콘텐츠 높이 (프레임보다 작게)
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

              // Buttons overlay
              Positioned(
                left: 20,
                top: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Google Play Store link
                      },
                      child: Text('Get it on Google Play'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // App Store link
                      },
                      child: Text('Download on the App Store'),
                    ),
                  ],
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