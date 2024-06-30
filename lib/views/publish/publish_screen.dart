import 'package:flutter/material.dart';
import 'package:life_bookshelf/viewModels/publish/publish_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';

class PublishScreen extends BaseScreen<PublishViewModel> {
  const PublishScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text("publish"),
    );
  }
}
