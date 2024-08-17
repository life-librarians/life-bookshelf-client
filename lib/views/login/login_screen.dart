import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:life_bookshelf/services/login/login_service.dart';
import '../../utilities/font_system.dart';
import '../../viewModels/login/login_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';

import '../register/register_screen.dart';

class LoginScreen extends BaseScreen<LoginViewModel> {
  const LoginScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFECEBF0),
        child: Stack(
          children: [
            _Airplane(),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Sign In',
                      style: FontSystem.KR32SB.copyWith(color: Color(0xFF2A4ECA)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 45),
                    _Middle(),
                    SizedBox(height: 31),
                    _Bottom(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Middle extends StatelessWidget {
  _Middle({Key? key}) : super(key: key);
  final LoginViewModel viewModel = Get.put(LoginViewModel(LoginService()));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton.icon(
          icon: SvgPicture.asset(
              'assets/icons/login/google_icon.svg',
              width: 24,
              height: 24,
          ),
          label: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text('Google', style: FontSystem.KR18M.copyWith(color: Color(0xFF61677D))),
          ),
          onPressed: () {
            // Google 로그인 로직
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF5F9FE),
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(  // 버튼의 곡률 조정
              borderRadius: BorderRadius.circular(14),  // 곡률 값 변경
            ),
            alignment: Alignment.centerLeft,
            elevation: 0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Row(
            children: <Widget>[
              Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: Text('Or', style: FontSystem.KR14R.copyWith(color: Color(0xFF262626))),
              ),
              Expanded(child: Divider()),
            ],
          ),
        ),
        Obx(() => TextField(
          focusNode: viewModel.emailFocusNode,
          style: FontSystem.KR16R.copyWith(color: Color(0xFF262626)),
          onChanged: (value) => viewModel.email.value = value,
          decoration: InputDecoration(
            labelText: "Email",
            labelStyle: FontSystem.KR16R.copyWith(color: Color(0xFF7C8BA0)),
            fillColor: Color(0xFFF5F9FE),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: viewModel.isEmailFocused.value ? Color(0xFF3461FD) : Colors.white,
                width: 1,
              ),
            ),
          ),
        )),
        SizedBox(height: 16),
        Obx(() => TextField(
          obscureText: !viewModel.passwordVisible.value,
          focusNode: viewModel.passwordFocusNode,
          style: FontSystem.KR16R.copyWith(color: Color(0xFF262626)),
          onChanged: (value) => viewModel.password.value = value,
          decoration: InputDecoration(
            labelText: "Password",
            labelStyle: FontSystem.KR16R.copyWith(color: Color(0xFF7C8BA0)),
            fillColor: Color(0xFFF5F9FE),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: viewModel.isPasswordFocused.value ? Color(0xFF3461FD) : Colors.white,
                width: 1,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.passwordVisible.value ? Icons.visibility_off : Icons.visibility,
                color: Color(0xFF3B4054),
              ),
              onPressed: () {
                viewModel.passwordVisible.value = !viewModel.passwordVisible.value;
              },
            ),
          ),
        )),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 24), // 오른쪽 패딩 24
            child: TextButton(
              onPressed: () {
                // Forgot Password Screen
              },
              child: Text(
                'Forget Password?',
                style: FontSystem.KR12R.copyWith(color: Color(0xFF7C8BA0)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _Bottom extends StatelessWidget {
  _Bottom({Key? key}) : super(key: key);
  final LoginViewModel viewModel = Get.find<LoginViewModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            bool isSuccess = await viewModel.login();
            if (isSuccess) {
              Get.snackbar(
                '로그인 성공',
                '로그인이 성공적으로 완료되었습니다.',
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 2),
              );
            } else {
              Get.snackbar(
                '로그인 실패',
                '로그인에 실패하였습니다. 다시 시도해주세요.',
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 2),
              );
            }
          },
          child: Text(
            'Log In',
            style: FontSystem.KR16M.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF567AF3),
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(left: 16), // 왼쪽 패딩 추가
          child: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: "Don't have account? ",
                style: FontSystem.KR14R.copyWith(color: Color(0xFF3B4054)),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Sign Up',
                    style: FontSystem.KR14R.copyWith(color: Color(0xFF567AF3)),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Get.to(() => RegisterScreen()); // 페이지 이동
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Airplane extends StatelessWidget {
  _Airplane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 34,
      left: 0,
      right: 253,
      child: Container(
        width: 150, // Width of the image
        height: 71, // Height of the image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login/airplane.png"), // Path to the image asset
            fit: BoxFit.fill
          ),
        ),
      ),
    );
  }
}