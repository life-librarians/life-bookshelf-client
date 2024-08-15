import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:life_bookshelf/services/login/login_service.dart';
import '../../services/register/register_service.dart';
import '../../utilities/font_system.dart';
import '../../viewModels/login/login_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';

import '../../viewModels/register/register_viewmodel.dart';
import '../login/login_screen.dart';

class RegisterScreen extends BaseScreen<RegisterViewModel> {
  const RegisterScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFECEBF0),
        child: Stack(
          children: [
            _Clouds(),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Sign Up',
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
  final RegisterViewModel viewModel = Get.put(RegisterViewModel(RegisterService()));

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
          onChanged: (value) => viewModel.emailController.text = value,
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
          onChanged: (value) => viewModel.passwordController.text = value,
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
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Obx(() => Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: viewModel.agreeToTerms.value,
                onChanged: (bool? value) {
                  viewModel.agreeToTerms.value = value ?? false;
                },
                checkColor: Color(0xFFF5F9FE),
                fillColor: MaterialStateProperty.resolveWith((states) =>
                viewModel.agreeToTerms.value ? Color(0xFF3461FD) : Color(0xFFF5F9FE)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: BorderSide(color: Colors.transparent),
              )),
            ),
            SizedBox(width: 5),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: FontSystem.KR12R.copyWith(color: Color(0xFF3B4054)),
                  children: <TextSpan>[
                    TextSpan(
                      text: "I agree to The ",
                    ),
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(color: Color(0xFF3461FD)),
                    ),
                    TextSpan(
                      text: " and ",
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(color: Color(0xFF3461FD)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _Bottom extends StatelessWidget {
  _Bottom({Key? key}) : super(key: key);
  final RegisterViewModel viewModel = Get.find<RegisterViewModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Obx(() => ElevatedButton(
          onPressed: viewModel.agreeToTerms.value ? () async {
            bool isSuccess = await viewModel.register();
            if (isSuccess) {
              Get.snackbar(
                '회원가입 성공',
                '회원가입이 성공적으로 완료되었습니다.',
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 2),
              );
            } else {
              Get.snackbar(
                '회원가입 실패',
                '회원가입에 실패하였습니다. 다시 시도해주세요.',
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 2),
              );
            }
          } : null,
          child: Text(
            'Create Account',
            style: FontSystem.KR16M.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: viewModel.agreeToTerms.value ? Color(0xFF567AF3) : Colors.grey,
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        )),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(left: 16), // 왼쪽 패딩 추가
          child: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: "Do you have account? ",
                style: FontSystem.KR14R.copyWith(color: Color(0xFF3B4054)),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Sign In',
                    style: FontSystem.KR14R.copyWith(color: Color(0xFF567AF3)),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Get.to(() => LoginScreen()); // 페이지 이동
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

class _Clouds extends StatelessWidget {
  _Clouds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 35,
          right: 281,
          child: Container(
            width: 127,
            height: 56,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/register/cloud_1.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Positioned(
          left: 239,
          bottom: 0,
          child: Container(
            width: 236,
            height: 111,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/register/cloud_2.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}