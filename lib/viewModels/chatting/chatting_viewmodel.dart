import 'package:get/get.dart';

class ChattingViewModel extends GetxController {
  final RxInt _micStateValue = 0.obs;

  MicState get micState => MicState.fromInt(_micStateValue.value);

  void changeMicState() {
    _micStateValue.value = (_micStateValue.value + 1) % 3;
    print("change mic state to $_micStateValue");
  }
}

/// Mic Button's State
/// 0 = ready (mic button)
/// 1 = in progress (stop button)
/// 2 = finish (check button)
enum MicState {
  ready(0),
  inProgress(1),
  finish(2);

  final int value;
  const MicState(this.value);

  static MicState fromInt(int value) {
    return MicState.values.firstWhere((e) => e.value == value % 3);
  }
}
