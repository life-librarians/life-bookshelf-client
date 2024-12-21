import 'package:get/get.dart';
import 'package:life_bookshelf/models/onboarding/onboarding_model.dart';
import 'package:life_bookshelf/services/onboarding/onboarding_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/mypage/mypage_service.dart';
import '../home/home_viewmodel.dart';
import 'package:life_bookshelf/viewModels/onboarding/questions.dart';
import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';
import 'package:life_bookshelf/viewModels/login/login_viewmodel.dart';

class OnboardingViewModel extends GetxController {
  var currentQuestionIndex = 0.obs;
  var answers = <String>[].obs;
  var currentQuestion = "".obs;
  var currentQuestionDetail = "".obs;
  var isDateValid = false.obs;
  var isNameValid = false.obs;
  var isButtonPressed = false.obs;

  final OnboardingApiService _userService = OnboardingApiService();
  final MyPageApiService _myPageApiService = MyPageApiService();

  Future<void> updateUserInformation() async {
    if (answers.length >= 7) {
      OnUserModel user = OnUserModel(
        name: answers[0],
        bornedAt: answers[1],
        gender: answers[2],
        hasChildren: answers[3].toLowerCase() == 'yes',
        occupation: answers[4],
        education_level: answers[5],
        marital_status: answers[6],
      );
      try {
        // 온보딩 만들기
        await _userService.updateUser(user);
        await _userService.createChapter();

        // 회원정보 넣기
        final userProfile = await _myPageApiService.fetchUserProfile(
          name: answers[0],
          bornedAt: answers[1],
          gender: answers[2],
          hasChildren: answers[3].toLowerCase() == 'yes',
        );

        // 로그인 다시 수행하여 토큰 갱신
        final loginViewModel = Get.find<LoginViewModel>();
        final loginSuccess = await loginViewModel.login();
        if (!loginSuccess) {
          throw Exception('로그인 실패: 토큰 갱신 실패');
        }

        // HomeViewModel 인스턴스 가져오기
        final homeViewModel = Get.find<HomeViewModel>();
        // 챕터 정보 갱신
        await homeViewModel.fetchAllData();

        await setOnboardingCompleted();
        Get.offAllNamed('/home');
      } catch (error, stackTrace) {
        // 에러와 스택 트레이스를 함께 출력
        print("Error updating user: $error");
        print("Stack Trace: $stackTrace");
      }
    } else {
      print("Not enough information to update user.");
    }
  }

  void updateAnswer(String text) {
    if (currentQuestionIndex.value >= answers.length) {
      answers.add(text);
    } else {
      answers[currentQuestionIndex.value] = text;
    }
  }

  void addCurrentQuestionIndex() {
    currentQuestionIndex.value++;
    print("Current question index: ${currentQuestionIndex.value}");
  }

  void updateCurrentQuestion() {
    currentQuestion.value = OnboardingQuestions.questions[currentQuestionIndex.value];
    currentQuestionDetail.value = OnboardingQuestions.questionsDetails[currentQuestionIndex.value];
  }

  void nextQuestion() {
    isButtonPressed.value = true;
    addCurrentQuestionIndex();
    updateCurrentQuestion();
    isButtonPressed.value = false;
  }

  void validateDate() {
    if (answers.length <= currentQuestionIndex.value && isButtonPressed.value == true) {
      isDateValid(false);
    } else {
      isDateValid(true);
    }
  }

  void validateName(String newName) {
    if (answers.length <= currentQuestionIndex.value && isButtonPressed.value == true) {
      isNameValid(false);
    } else {
      isNameValid(true);
    }
  }

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    print("Onboarding completed: ${prefs.getBool('onboardingCompleted')}");
    return prefs.getBool('onboardingCompleted') ?? false;
    // return true; // TODO: 다른 기기, 온보딩을 완료한 계정으로 수행 시 onboarding == null인 문제
  }

  Future<void> clearOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('onboardingCompleted');
    print("Onboarding status has been cleared");
  }
}
