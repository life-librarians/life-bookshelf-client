import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/views/onboarding/onboarding_screen.dart';
import '../../services/image_upload_service.dart';
import '../../services/login/login_service.dart';
import '../../services/userpreferences_service.dart';
import '../onboarding/onboarding_viewmodel.dart';

class LoginViewModel extends GetxController {
  final LoginService loginService;
  var isLoading = false.obs;
  var loginError = Rxn<String>();
  var authToken = Rxn<String>();

  // FocusNode와 포커스 상태 관리
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  var isEmailFocused = false.obs;
  var isPasswordFocused = false.obs;
  var passwordVisible = false.obs;
  var email = ''.obs;
  var password = ''.obs;

  LoginViewModel(this.loginService) {
    emailFocusNode.addListener(() {
      isEmailFocused.value = emailFocusNode.hasFocus;
    });
    passwordFocusNode.addListener(() {
      isPasswordFocused.value = passwordFocusNode.hasFocus;
    });
  }

  Future<void> initializeControllers() async {
    // OnboardingViewModel 초기화
    if (!Get.isRegistered<OnboardingViewModel>()) {
      Get.put(OnboardingViewModel(), permanent: true);
    }

    // 필수 서비스들 초기화
    if (!Get.isRegistered<ImageUploadService>()) {
      Get.put(ImageUploadService(), permanent: true);
    }
  }

  Future<bool> login() async {
    isLoading(true);
    try {
      final response = await loginService.postLogin(email.value, password.value);
      authToken.value = response.accessToken;
      await UserPreferences.setUserToken(response.accessToken);

      // 필요한 컨트롤러들 초기화
      await initializeControllers();

      // OnboardingViewModel 가져오기
      final onboardingViewModel = Get.find<OnboardingViewModel>();
      final bool onboardingCompleted = await loginService.checkOnboardingStatus();

      // 현재 로그인 화면만 스택에서 제거
      if (onboardingCompleted) {
        print("로그인 성공: 홈 화면으로 이동 시도");
        await Get.offAllNamed('/home');
        print("홈 화면 이동 완료");
      } else {
        // 온보딩이 필요한 경우
        print("온보딩 필요: 온보딩 화면으로 이동");
        final onboardingScreen = OnboardingScreen();
        await Get.offAll(() => onboardingScreen);
      }

      return true;
    } catch (e) {
      print('Login failed: $e');
      loginError.value = e.toString();
      return false;
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  void clearError() {
    loginError.value = null;
  }

  bool isUserLoggedIn() {
    return authToken.value != null && authToken.value!.isNotEmpty;
  }
}