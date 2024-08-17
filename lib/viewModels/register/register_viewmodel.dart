import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/register/register_service.dart';
import '../../views/home/home_screen.dart';
import '../../views/login/login_screen.dart';

class RegisterViewModel extends GetxController {
  final RegisterService registerService;
  var isLoading = false.obs;
  var registerError = Rxn<String>();

  // FocusNode와 포커스 상태 관리
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  var isEmailFocused = false.obs;
  var isPasswordFocused = false.obs;
  var passwordVisible = false.obs;
  var agreeToTerms = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterViewModel(this.registerService) {
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
  Future<bool> register() async {
    isLoading(true);
    try {
      final response = await registerService.postRegister(emailController.text, passwordController.text);
      print('Register successful');
      return true;
    } catch (e) {
      registerError.value = e.toString();
      print('Login failed: $registerError');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // 에러 메시지를 클리어하는 메소드
  void clearError() {
    registerError.value = null;
  }
}