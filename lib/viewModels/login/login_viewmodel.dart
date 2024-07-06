import 'package:get/get.dart';
import '../../services/login/login_service.dart';

class LoginViewModel extends GetxController {
  final LoginService loginService;

  var isLoading = false.obs;
  var loginError = Rxn<String>();
  var authToken = Rxn<String>();

  LoginViewModel(this.loginService);

  @override
  void onInit() {
    super.onInit();
  }

  // 로그인을 시도하고 결과를 처리하는 메소드
  Future<void> login(String email, String password) async {
    try {
      isLoading(true);
      final response = await loginService.postLogin(email, password);
      authToken.value = response.accessToken; // accessToken을 상태로 저장
      print('Login successful with token: ${authToken.value}');
    } catch (e) {
      loginError.value = e.toString(); // 에러 메시지를 상태로 저장
      print('Login failed: $loginError');
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