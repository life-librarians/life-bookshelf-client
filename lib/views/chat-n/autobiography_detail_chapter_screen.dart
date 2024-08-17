import 'package:flutter/material.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:get/get.dart';
import 'package:life_bookshelf/views/chat-n/widget/after_fix.dart';
import 'package:life_bookshelf/views/chat-n/widget/before_fix.dart';
import 'package:life_bookshelf/views/chat-n/widget/during_fix.dart';
import '../../services/chat-n/autobiography_service.dart';
import '../../utilities/font_system.dart';
import '../../viewModels/chat-n/autobiography_viewmodel.dart';

class AutobiographyDetailScreen extends BaseScreen<AutobiographyViewModel> {
  final int autobiographyId;
  const AutobiographyDetailScreen({Key? key, required this.autobiographyId}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    final AutobiographyViewModel viewModel = Get.find<AutobiographyViewModel>();

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

  @override
  Widget buildBody(BuildContext context) {
    final AutobiographyViewModel viewModel = Get.put(AutobiographyViewModel(Get.find<ChatAutobiographyService>()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchAutobiography(autobiographyId);
      viewModel.isFixMode.value = false;
      viewModel.isAfterFixMode.value = false;
    });

    return GetBuilder<AutobiographyViewModel>(
      init: viewModel,
      builder: (viewModel) {
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
                return _buildContentBasedOnMode(viewModel);
              } else {
                return Center(child: Text('No Data'));
              }
            }),
          ),
        );
      },
    );
  }

  Widget _buildContentBasedOnMode(AutobiographyViewModel viewModel) {
    if (viewModel.isAfterFixMode.value) {
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
    } else if (viewModel.isFixMode.value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopFixBuild(
            onFixPressed: () {
              viewModel.toggleFixMode();
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
              viewModel.toggleFixMode();
            },
          ),
          SizedBox(height: 22),
          FirstContentBuild(),
          SizedBox(height: 22),
          RestContentBuild(),
        ],
      );
    }
  }
}
