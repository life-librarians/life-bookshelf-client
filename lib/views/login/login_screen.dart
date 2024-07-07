import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; // SVG 이미지를 사용하기 위해 필요
import '../../viewModels/login/login_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';

class LoginScreen extends BaseScreen<LoginViewModel> {
  const LoginScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Sign In',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48),
            // Google Sign-in Button
            ElevatedButton.icon(
              icon: SvgPicture.asset(
                'assets/icons/google_icon.svg', // Google 로고 이미지 경로 확인 필요
                width: 24,
                height: 24,
              ),
              label: Text('Google'),
              onPressed: () {
                // Google 로그인 로직
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Or'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
            ),
            // Email input field
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 12),
            // Password input field
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Forgot Password Screen
                },
                child: Text('Forget Password?'),
              ),
            ),
            SizedBox(height: 20),
            // Login button
            ElevatedButton(
              onPressed: () {
                // Perform login
              },
              child: Text('Log In'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  // Navigate to Sign Up Screen
                },
                child: Text.rich(
                  TextSpan(
                    text: "Don't have account? ",
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
