import 'package:get/get.dart';

class MypageViewModel extends GetxController {
  List<RxBool> switches = List.generate(6, (_) => false.obs); // Generates 5 observable booleans

  void toggleSwitch(int index, bool value) {
    if (index < switches.length) {
      switches[index].value = value;
    }
  }
}
