import 'package:flutter/material.dart';
import 'package:life_bookshelf/viewModels/home/autobiography_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:get/get.dart';
import '../../utilities/font_system.dart';

class AutobiographyDetailScreen extends BaseScreen<AutobiographyViewModel> {
  final int autobiographyId;
  const AutobiographyDetailScreen({Key? key, required this.autobiographyId}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
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
        'Detail Chapter',
        style: FontSystem.KR16_58SB.copyWith(color: Colors.black),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // ViewModel 인스턴스를 가져오고 초기화
    final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();
    viewModel.fetchAutobiography(autobiographyId);

    return GetBuilder<AutobiographyDetailController>(
      init: AutobiographyDetailController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: Get.height,
            padding: const EdgeInsets.fromLTRB(27, 5, 27, 27),
            child: Obx(() {
              if (viewModel.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (viewModel.errorMessage.isNotEmpty) {
                return Center(child: Text(viewModel.errorMessage.value));
              } else if (viewModel.autobiography.value != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.isFixMode.value
                      ? [
                    _TopBuild(),
                    SizedBox(height: 5),
                    _TopHelpBuild(),
                    SizedBox(height: 35),
                    _FixContentBuild(),
                        ]
                      : [
                    _TopBuild(),
                    SizedBox(height: 22),
                    _ImageBuild(),
                    SizedBox(height: 19.87),
                    _ContentPreviewBuild(
                      onFixPressed: () {
                        controller.toggleFixMode();
                      },
                    ),
                    SizedBox(height: 22),
                    _FirstContentBuild(),
                    SizedBox(height: 22),
                    _RestContentBuild(),
                  ],
                );
              } else {
                return Center(child: Text('No Data'));
              }
            }),
          ),
        );
      },
    );
  }
}

// 수정하기 버튼 컨트롤러
class AutobiographyDetailController extends GetxController {
  var isFixMode = false.obs;

  void toggleFixMode() {
    isFixMode.value = !isFixMode.value;
  }
}

class _TopBuild extends StatelessWidget {
  _TopBuild({Key? key}) : super(key: key);
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/icons/detail-chapter.png',
          width: 33.16,
          height: 33.16,
        ),
        SizedBox(width: 12.43),
        Text(
          viewModel.autobiography.value!.title ?? "Detail Chapter",
          style: FontSystem.KR14_51SB.copyWith(color: Colors.black),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            // 버튼 클릭 시 동작 추가
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.transparent, // 버튼 투명하게 설정
            minimumSize: Size(103, 32),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Color(0xFFBCC5D8), width: 1),
            ),
          ),
          child: Text(
            '다시 채팅하기',
            style: FontSystem.KR12SB.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _ImageBuild extends StatelessWidget {
  _ImageBuild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // Todo: 이미지 연동
      child: Image.asset(
        'assets/images/detail-chapter-dummyImg.png',
        height: 290.15,
      ),
    );
  }
}

class _ContentPreviewBuild extends StatelessWidget {
  _ContentPreviewBuild({Key? key, required this.onFixPressed}) : super(key: key);
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();
  final VoidCallback onFixPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          viewModel.autobiography.value!.contentPreview ?? "content preview",
          style: FontSystem.KR20_72SB.copyWith(color: Color(0xFF192252)),
        ),
        Spacer(),
        GestureDetector(
          onTap: onFixPressed,
          child: Image.asset(
            'assets/images/detail-chapter-fixbutton.png',
            width: 35,
            height: 45,
          ),
        ),
      ],
    );
  }
}

class _FirstContentBuild extends StatelessWidget {
  _FirstContentBuild({Key? key}) : super(key: key);
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          viewModel.autobiography.value!.content!.substring(0, 1),
          style: TextStyle(
            fontSize: 40,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              viewModel.autobiography.value!.content!.substring(1),
              style: FontSystem.KR14_51M.copyWith(color: Color(0xFF838999)),
            ),
          ),
        ),
      ],
    );
  }
}

// Todo: 회의 때 얘기하기 -> 단락을 어떻게 나눌 것인가?
class _RestContentBuild extends StatelessWidget {
  _RestContentBuild({Key? key}) : super(key: key);
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        viewModel.autobiography.value!.content!.substring(1),
        style: FontSystem.KR14_51M.copyWith(color: Color(0xFF838999)),
      ),
    );
  }
}

class _TopHelpBuild extends StatelessWidget {
  _TopHelpBuild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "최대한 주제에 어긋나지 않는 한에서 수정 해주신 뒤, 수정완료를 눌러주세요. 교정 교열은 저희가 도와드려요.",
      style: FontSystem.KR12R.copyWith(color: Color(0xFF7B7B7B)),
    );
  }
}

class _FixContentBuild extends StatelessWidget {
  _FixContentBuild({Key? key}) : super(key: key);
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          viewModel.autobiography.value!.contentPreview ?? "content preview",
          style: FontSystem.KR20_72SB.copyWith(color: Color(0xFF192252)),
        ),
      ],
    );
  }
}