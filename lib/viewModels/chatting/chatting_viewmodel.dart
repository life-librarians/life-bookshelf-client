import 'package:get/get.dart';
import 'package:life_bookshelf/views/chatting/chatBubble.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChattingViewModel extends GetxController {
  final RxInt _micStateValue = 0.obs;
  final stt.SpeechToText _speech = stt.SpeechToText();
  final RxString _currentSpeech = ''.obs;
  final RxList<ChatBubble> chatBubbles = <ChatBubble>[].obs;

  MicState get micState => MicState.fromInt(_micStateValue.value);
  String get currentSpeech => _currentSpeech.value;

  Future<void> changeMicState() async {
    _micStateValue.value = (_micStateValue.value + 1) % 3;

    if (micState == MicState.inProgress) {
      await _startListening();
    } else if (micState == MicState.finish) {
      await _stopListening();
    }
  }

  Future<void> _startListening() async {
    _currentSpeech.value = '';
    chatBubbles.add(const ChatBubble(isUser: true, message: ''));

    bool available = await _speech.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (errorNotification) => print('onError: $errorNotification'),
    );

    if (available) {
      _speech.listen(
        onResult: (result) {
          _currentSpeech.value = result.recognizedWords;
          chatBubbles.last = ChatBubble(isUser: true, message: _currentSpeech.value);
        },
      );
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    _currentSpeech.value = '';
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
