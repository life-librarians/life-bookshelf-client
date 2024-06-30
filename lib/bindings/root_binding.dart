import 'package:get/get.dart';
import 'package:life_bookshelf/viewModels/home/home_viewmodel.dart';
import 'package:life_bookshelf/viewModels/root/root_viewmodel.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    // ParentViewModel is singleton
    Get.put(RootViewModel());

    // ChildViewModel is singleton
    Get.put(HomeViewModel());
  }
}
