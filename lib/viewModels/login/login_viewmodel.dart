import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/views/onboarding/onboarding_screen.dart';
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
    // 포커스 노드 리스너 설정
    emailFocusNode.addListener(() {
      isEmailFocused.value = emailFocusNode.hasFocus;
    });
    passwordFocusNode.addListener(() {
      isPasswordFocused.value = passwordFocusNode.hasFocus;
    });
  }

  @override
  void onClose() {
    // 리소스 정리
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  // 로그인을 시도하고 결과를 처리하는 메소드
  Future<bool> login() async {
    isLoading(true);
    try {
      final response = await loginService.postLogin(email.value, password.value);
      authToken.value = response.accessToken;
      print('Login successful with token: ${authToken.value}');
      await UserPreferences.setUserToken(response.accessToken);

      final OnboardingViewModel viewmodel = Get.find<OnboardingViewModel>();
      final onboardingCompleted = await viewmodel.isOnboardingCompleted();

      if(onboardingCompleted) {
        Get.toNamed('/home');
      } else {
        Get.to(OnboardingScreen());
      }

      return true;
    } catch (e) {
      loginError.value = e.toString(); // 에러 메시지를 상태로 저장
      print('Login failed: $loginError');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // 에러 메시지를 클리어하는 메소드
  void clearError() {
    loginError.value = null;
  }

  // 로그인 상태 확인 (예: 토큰의 존재 유무)
  bool isUserLoggedIn() {
    return authToken.value != null && authToken.value!.isNotEmpty;
  }
}
