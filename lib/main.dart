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
  /* Open .env file */
  await dotenv.load(fileName: "assets/config/.env");
  await initializeDateFormatting();
  await UserPreferences.init();

  Get.put(OnboardingViewModel());
  Get.put(RootViewModel());
  Get.put(ImageUploadService());

  final OnboardingViewModel viewmodel = Get.find<OnboardingViewModel>();
  final onboardingCompleted = await viewmodel.isOnboardingCompleted();
  //온보딩 다시 하고싶을때 취소
  //viewmodel.clearOnboardingStatus();

  runApp(MainApp(initialRoute: "/", onboardingCompleted: onboardingCompleted));
}
