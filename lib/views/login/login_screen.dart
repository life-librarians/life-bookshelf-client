import 'package:flutter/material.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import '../../viewModels/login/login_viewmodel.dart';

class LoginScreen extends BaseScreen<LoginViewModel> {
  const LoginScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text("mypage"),
    );
  }
}
