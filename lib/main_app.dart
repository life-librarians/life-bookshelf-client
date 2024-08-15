import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/bindings/root_binding.dart';
import 'package:life_bookshelf/utilities/screen_utils.dart';
import 'package:life_bookshelf/views/login/login_screen.dart';
import 'package:life_bookshelf/views/onboarding/onboarding_screen.dart';
import 'views/root/root_screen.dart';

class MainApp extends StatelessWidget {
  final bool onboardingCompleted;

  const MainApp({
    super.key,
    required this.onboardingCompleted,
    required String initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    // Remove splash
    FlutterNativeSplash.remove();
    ScreenUtils().init(context);

    return GetMaterialApp(
      initialBinding: RootBinding(),
      title: "Life Bookshelf",
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard',
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFf6f6f8),
      ),
      home: onboardingCompleted ? const RootScreen() : LoginScreen(),
      getPages: [
        GetPage(
            name: '/', page: () => const RootScreen(), binding: RootBinding()),
        GetPage(
            name: '/login',
            page: () => LoginScreen(),
            binding: RootBinding()),
      ],
    );
  }
}
