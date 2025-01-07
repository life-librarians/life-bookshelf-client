import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/utilities/screen_utils.dart';
import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/login/login_screen.dart';
import 'package:life_bookshelf/views/mypage/components/publication_progress.dart';
import 'package:life_bookshelf/views/mypage/components/toggle.dart';
import 'package:life_bookshelf/viewModels/onboarding/onboarding_viewmodel.dart';
import 'package:life_bookshelf/services/userpreferences_service.dart';

import '../../services/login/login_service.dart';
import '../../utilities/app_routes.dart';
import '../../viewModels/login/login_viewmodel.dart';

class MypageScreen extends BaseScreen<MypageViewModel> {
  const MypageScreen({super.key});
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFF7F7F7),
      title: Text(
        'Mypage',
        style: FontSystem.KR16_58SB.copyWith(color: Colors.black),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final viewmodel = Get.find<MypageViewModel>();
    return Obx(() {
      if (viewmodel.isLoading.isTrue) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: const Column(
              children: [
                _Profile(),
                PublicationProgress(),
                _BooksPublished(),
                _More(),
              ],
            ),
          ),
        );
      }
    });
  }
}

class _Profile extends StatelessWidget {
  const _Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = Get.find<MypageViewModel>();
    return Container(
      decoration: BoxDecoration(
        color: ColorSystem.deepBlue,
        borderRadius: BorderRadius.circular(13),
      ),
      width: Get.width * 0.89,
      height: 76,
      child: Padding(
        padding: const EdgeInsets.only(left: 23, top: 16, bottom: 13),
        child: Row(children: [
          SvgPicture.asset(
            'assets/icons/mypage/profile.svg',
            width: 42,
            height: 42,
          ),
          const SizedBox(width: 13),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewmodel.userModel.value?.name ?? 'Dummy',
                style: FontSystem.KR16M.copyWith(color: Colors.white, height: 1),
              ),
              const SizedBox(height: 15),
              Text(
                viewmodel.userModel.value?.bornedAt ?? '2001-02-24',
                style: FontSystem.KR11M.copyWith(color: Colors.white, height: 1),
              ),
            ],
          ),
          SizedBox(width: Get.width * 0.45),
          SvgPicture.asset('assets/icons/mypage/pen.svg')
        ]),
      ),
    );
  }
}

class _BooksPublished extends StatelessWidget {
  const _BooksPublished({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 31),
      width: Get.width * 0.89,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("내가 출판한 책", style: FontSystem.KR14B.copyWith(color: ColorSystem.mypage.fontBlack)),
        Text(
          "책의 오른쪽 상단 버튼을 터치하면 다시 비공개, 혹은 공개로 만들수있어요.",
          style: FontSystem.KR10M.copyWith(color: ColorSystem.mypage.fontGray),
        ),
        const _BookBoxs(),
      ]),
    );
  }
}

class _BookBoxs extends StatelessWidget {
  const _BookBoxs({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ViewModel
    final MypageViewModel viewModel = Get.find<MypageViewModel>();

    return SizedBox(
      height: 41,
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.bookList.value?.results.length ?? 0, // Use actual count from bookList
            itemBuilder: (context, index) {
              final book = viewModel.bookList.value?.results[index]; // Get book details
              return _BookBox(
                title: book?.title ?? "No Title", // Pass the title
                // visibility: book?.visibleScope == "PUBLIC" ? "공개" : "비공개"  // Determine visibility
              );
            },
          )),
    );
  }
}

class _BookBox extends StatelessWidget {
  final String title;

  const _BookBox({
    super.key,
    required this.title,
  });

  void _showModal() {
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            '자서전을 만들고 있어요',
            style: FontSystem.KR20B,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            '여행자님과의 대화들로부터 자서전을 만들고있어요. 모두 완성된 뒤에는 알림으로 알려드릴게요. 평균 2일 소요되어요.',
            style: FontSystem.KR13R.copyWith(color: ColorSystem.chatting.modalContentColor),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorSystem.white,
                    backgroundColor: ColorSystem.accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    fixedSize: Size.fromHeight(42.h),
                  ),
                  child: Text('확인했어요', style: FontSystem.KR14SB.copyWith(color: ColorSystem.white)),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showModal();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 9),
        width: Get.width * 0.34,
        height: 41,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.23),
          image: DecorationImage(
            image: const AssetImage("assets/icons/main/example.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.69),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: FontSystem.KR10B.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _More extends StatelessWidget {
  const _More({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: Get.width * 0.89,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("More", style: FontSystem.KR14B.copyWith(color: ColorSystem.mypage.fontBlack)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            height: 220,
            child: const Column(
              children: [
                _Remind(),
                _Logout(),
                _Withdrawal(),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Remind extends StatelessWidget {
  const _Remind({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 23),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/mypage/remind.svg'),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "리마인드 푸시알림 설정",
                style: FontSystem.KR13M,
              ),
              Text(
                "설정하시면 저녁 8시에 알림이 가요",
                style: FontSystem.KR11M.copyWith(color: ColorSystem.mypage.fontGray),
              ),
            ],
          ),
          SizedBox(width: Get.width * 0.11),
          SimpleToggleSwitch(index: 0),
        ],
      ),
    );
  }
}

class _Logout extends StatelessWidget {
  const _Logout({super.key});

  // 로그아웃 처리 함수
  Future<void> handleLogout(BuildContext context) async {
    try {
      await UserPreferences.clearUserToken();

      // OnboardingViewModel이 없을 경우를 대비해 새로 생성
      if (!Get.isRegistered<OnboardingViewModel>()) {
        Get.put(OnboardingViewModel());
      }
      final onboardingViewModel = Get.find<OnboardingViewModel>();
      onboardingViewModel.clearOnboardingStatus();

      // 모든 GetX 컨트롤러와 라우트 스택을 제거
      await Get.deleteAll(force: true);

      // 새로운 LoginScreen 인스턴스로 이동
      await Get.offAll(
            () => const LoginScreen(),
        predicate: (route) => false,
        binding: BindingsBuilder(() {
          Get.put(LoginViewModel(LoginService()));
        }),
      );
    } catch (e) {
      print('Logout error: $e');
      // 에러가 발생해도 로그인 화면으로는 이동
      await Get.offAll(() => const LoginScreen());
    }
  }

  void _showLogoutDialog(BuildContext context, MypageViewModel viewModel) {
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            '로그아웃',
            style: FontSystem.KR20B,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            '로그아웃 하시겠습니까?',
            style: FontSystem.KR13R.copyWith(color: Colors.black),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorSystem.white,
                    backgroundColor: ColorSystem.accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  ),
                  child: Text('취소', style: FontSystem.KR14SB.copyWith(color: ColorSystem.white)),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorSystem.white,
                    backgroundColor: ColorSystem.accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  ),
                  child: Text('확인', style: FontSystem.KR14SB.copyWith(color: ColorSystem.white)),
                  onPressed: () => handleLogout(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MypageViewModel viewModel = Get.find<MypageViewModel>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showLogoutDialog(context, viewModel),
        child: Container(
          margin: const EdgeInsets.only(left: 16, top: 23),
          padding: const EdgeInsets.only(right: 16),
          width: Get.width,
          height: 50,
          child: Row(
            children: [
              SvgPicture.asset('assets/icons/mypage/out.svg'),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "로그아웃",
                    style: FontSystem.KR13M,
                  ),
                  Text(
                    "다음에 또 만나요!",
                    style: FontSystem.KR11M.copyWith(color: ColorSystem.mypage.fontGray),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Withdrawal extends StatelessWidget {
  const _Withdrawal({super.key});

  void _showWithdrawalDialog(BuildContext context, MypageViewModel viewModel) {
    final OnboardingViewModel onboardingViewModel = Get.find<OnboardingViewModel>();
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            '회원탈퇴',
            style: FontSystem.KR20B,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            '정말로 회원탈퇴를 진행하시겠습니까? 탈퇴 후 데이터는 30일 뒤에 삭제됩니다.',
            style: FontSystem.KR13R.copyWith(color: Colors.black),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorSystem.white,
                    backgroundColor: ColorSystem.accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  ),
                  child: Text('취소', style: FontSystem.KR14SB.copyWith(color: ColorSystem.white)),
                  onPressed: () => Get.back(), // 다이얼로그 닫기
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorSystem.white,
                    backgroundColor: ColorSystem.accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  ),
                  child: Text('확인', style: FontSystem.KR14SB.copyWith(color: ColorSystem.white)),
                  onPressed: () async {
                    await viewModel.deleteUser();
                    onboardingViewModel.clearOnboardingStatus();
                    Get.offAll(() => const LoginScreen()); // 모든 화면을 pop하고 로그인 화면으로 이동
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MypageViewModel viewModel = Get.find<MypageViewModel>();

    return Material(  // InkWell을 사용하기 위해 Material 위젯 추가
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showWithdrawalDialog(context, viewModel),
        child: Container(
          margin: const EdgeInsets.only(left: 16, top: 23),
          padding: const EdgeInsets.only(right: 16),  // 오른쪽 여백 추가
          width: Get.width,
          height: 50,  // 클릭 영역을 위한 고정 높이 설정
          child: Row(
            children: [
              SvgPicture.asset('assets/icons/mypage/trash.svg'),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8,),
                  const Text(
                    "회원탈퇴",
                    style: FontSystem.KR13M,
                  ),
                  Text(
                    "여행자님의 데이터는 30일 뒤에 삭제되어요.",
                    style: FontSystem.KR11M.copyWith(color: ColorSystem.mypage.fontGray),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}