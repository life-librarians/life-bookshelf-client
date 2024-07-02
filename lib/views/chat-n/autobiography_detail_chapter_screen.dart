import 'package:flutter/material.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/views/chat-N/widget/after_fix.dart';
import 'package:life_bookshelf/views/chat-N/widget/before_fix.dart';
import 'package:life_bookshelf/views/chat-N/widget/during_fix.dart';
import '../../utilities/font_system.dart';
import '../../viewModels/chat-N/autobiography_viewmodel.dart';
import '../chat-N/controllers/autobiography_detail_controller.dart';

class AutobiographyDetailScreen extends BaseScreen<AutobiographyViewModel> {
  final int autobiographyId;
  const AutobiographyDetailScreen({Key? key, required this.autobiographyId}) : super(key: key);

  // App Bar
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
        'Detail Chapter',
        style: FontSystem.KR16_58SB.copyWith(color: Colors.black),
      ),
    );
  }

  // Body
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
            color: Color(0xFFF7F7F7),
            padding: const EdgeInsets.fromLTRB(27, 5, 27, 27),
            child: Obx(() {
              if (viewModel.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (viewModel.errorMessage.isNotEmpty) {
                return Center(child: Text(viewModel.errorMessage.value));
              } else if (viewModel.autobiography.value != null) {
                if (controller.isAfterFixMode.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopAfterFixBuild(),
                      SizedBox(height: 5),
                      TopAfterFixHelpBuild(),
                      SizedBox(height: 35),
                      AfterFixContentBuild(),
                    ],
                  );
                } else if (controller.isFixMode.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopFixBuild(
                        onFixPressed: () {
                          controller.toggleFixMode();
                        },
                      ),
                      SizedBox(height: 5),
                      TopHelpBuild(),
                      SizedBox(height: 35),
                      FixContentBuild(),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopBuild(),
                      SizedBox(height: 22),
                      ImageBuild(),
                      SizedBox(height: 19.87),
                      ContentPreviewBuild(
                        onFixPressed: () {
                          controller.toggleFixMode();
                        },
                      ),
                      SizedBox(height: 22),
                      FirstContentBuild(),
                      SizedBox(height: 22),
                      RestContentBuild(),
                    ],
                  );
                }
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
