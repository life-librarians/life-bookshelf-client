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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
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
            final autobiography = viewModel.autobiography.value!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopBuild(),
                SizedBox(height: 27,),
                ImageBuild(),
                SizedBox(height: 24.87,),
                ContentPreviewBuild(),
                SizedBox(height: 27,),
                ContentBuild(),
              ],
            );
          } else {
            return Center(child: Text('No Data'));
          }
        }),
      ),
    );
  }
}

class TopBuild extends StatelessWidget {
  TopBuild({Key? key}) : super(key: key);
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

class ImageBuild extends StatelessWidget {
  ImageBuild({Key? key}) : super(key: key);

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

class ContentPreviewBuild extends StatelessWidget {
  ContentPreviewBuild({Key? key}) : super(key: key);
  final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          viewModel.autobiography.value!.contentPreview ?? "content preview",
          style: FontSystem.KR20_72SB.copyWith(color: Colors.black),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            // 버튼 클릭 시 동작 추가
          },
          child: Image.asset(
            'assets/images/detail-chapter-fixbutton.png',
            width: 35, // 이미지 너비
            height: 45, // 이미지 높이
          ),
        ),
      ],
    );
  }
}

class ContentBuild extends StatelessWidget {
  ContentBuild({Key? key}) : super(key: key);
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
            height: 1.1, // 텍스트 높이를 조정하여 라인 높이를 맞춤
          ),
        ),
        SizedBox(width: 8), // 첫 글자와 나머지 텍스트 사이의 간격
        Expanded(
          child: Text(
            viewModel.autobiography.value!.content!.substring(1),
            style: TextStyle(
              fontSize: 14.51,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
