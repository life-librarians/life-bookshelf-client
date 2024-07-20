import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/utilities/color_system.dart';
import 'package:life_bookshelf/utilities/font_system.dart';
import 'package:life_bookshelf/utilities/screen_utils.dart';
import 'package:life_bookshelf/viewModels/mypage/mypage_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/mypage/components/publication_progress.dart';
import 'package:life_bookshelf/views/mypage/components/toggle.dart';

class MypageScreen extends BaseScreen<MypageViewModel> {
  const MypageScreen({super.key});
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFF7F7F7),
      leading: Padding(
        padding: const EdgeInsets.only(left: 27.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 16),
          onPressed: () {
            Get.back();
          },
        ),
      ),
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
        return Center(child: CircularProgressIndicator());
      } else {
        return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              _Profile(),
              PublicationProgress(),
              _BooksPublished(),
              _More(),
            ],
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
        padding: const EdgeInsets.only(left: 23, top: 17, bottom: 17),
        child: Row(
          children:[
            SvgPicture.asset(
              'assets/icons/mypage/profile.svg',
              width: 42,
              height: 42,
            ),
            SizedBox(width: 13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewmodel.userModel.value?.name ?? '황현정',
                  style: FontSystem.KR16M.copyWith(color: Colors.white),
                ),
                Text(
                  viewmodel.userModel.value?.bornedAt ?? '2001-02-24',
                  style: FontSystem.KR11M.copyWith(color: ColorSystem.white),
                ),
              ],
            ),
            SizedBox(width: Get.width * 0.45),
            SvgPicture.asset('assets/icons/mypage/pen.svg')
          ]
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text("내가 출판한 책", style: FontSystem.KR14B.copyWith(color: ColorSystem.mypage.fontBlack)),
          Text("책의 오른쪽 상단 버튼을 터치하면 다시 비공개, 혹은 공개로 만들수있어요.",
            style: FontSystem.KR10M.copyWith(color: ColorSystem.mypage.fontGray),
          ),
          _BookBoxs(),
        ]
      ),
    );
  }
}


class _BookBoxs extends StatelessWidget {
  const _BookBoxs({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ViewModel
    final MypageViewModel viewModel = Get.find<MypageViewModel>();

    return Container(
      height: 41,
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.bookList.value?.results.length ?? 0,  // Use actual count from bookList
        itemBuilder: (context, index) {
          final book = viewModel.bookList.value?.results[index];  // Get book details
          return _BookBox(
              title: book?.title ?? "No Title",  // Pass the title
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
            image: AssetImage("assets/icons/main/example.png"),
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
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            height: 157,
            child: Column(
              children: [
                _Remind(),
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
          SizedBox(width: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("리마인드 푸시알림 설정",style:FontSystem.KR13M,),
              Text("설정하시면 저녁 8시에 알림이 가요",style: FontSystem.KR11M.copyWith(color: ColorSystem.mypage.fontGray),),
            ],
          ),
          SizedBox(width: Get.width * 0.18),
          SimpleToggleSwitch(index: 0),
        ],
      ),
    );
  }
}

class _Withdrawal extends StatelessWidget {
  const _Withdrawal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 23),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/mypage/out.svg'),
          SizedBox(width: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("회원탈퇴",style:FontSystem.KR13M,),
              Text("여행자님의 데이터는 30일 뒤에 삭제되어요.",style: FontSystem.KR11M.copyWith(color: ColorSystem.mypage.fontGray),),
            ]
          ),
          SizedBox(width: Get.width * 0.18),
          Container(
            margin: const EdgeInsets.only(top: 10),
              child: SvgPicture.asset('assets/icons/mypage/arrow.svg')),

        ],
      ),
    );
  }
}

