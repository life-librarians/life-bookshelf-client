import 'package:get/get.dart';
import 'package:life_bookshelf/models/chatting/conversation_model.dart';
import 'package:life_bookshelf/services/chatting/chatting_service.dart';
import 'package:life_bookshelf/views/chatting/chatBubble.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChattingViewModel extends GetxController {
  final ChattingService _apiService = Get.find<ChattingService>();
  final RxInt _micStateValue = 0.obs;
  final stt.SpeechToText _speech = stt.SpeechToText();
  final RxString _currentSpeech = ''.obs;
  final RxList<ChatBubble> chatBubbles = <ChatBubble>[].obs;
  final RxList<Conversation> conversations = <Conversation>[].obs;
  final RxBool isLoading = true.obs;

  // 사전에 생성한 질문 리스트 (예시)
  final List<String> predefinedQuestions = [
    "어린 시절 가장 행복했던 순간은 언제인가요?",
    "가장 힘들었던 경험은 무엇이었나요?",
    "인생에서 가장 중요한 결정은 무엇이었나요?",
    "가장 존경하는 인물은 누구인가요?",
    "미래에 이루고 싶은 꿈은 무엇인가요?"
  ];

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  bool initialized = false;

  MicState get micState => MicState.fromInt(_micStateValue.value);
  String get currentSpeech => _currentSpeech.value;

  /// 현재 진행 중인 페이지에 들어갈 시 진행 중이던 대화 initializing.
  Future<void> loadConversations(int autobiographyId, {int page = 1, int size = 20}) async {
    try {
      isLoading(true);
      final loadedConversations = await _apiService.getConversations(autobiographyId, page, size);
      conversations.value = loadedConversations;
      updateChatBubbles();
    } catch (e) {
      Get.snackbar('오류', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void updateChatBubbles() {
    chatBubbles.value = conversations
        .map((conv) => ChatBubble(
              isUser: conv.conversationType == 'HUMAN',
              message: conv.content,
              isFinal: true,
            ))
        .toList();
  }

  /// 채팅 화면 아래 버튼 state 변경
  Future<void> changeMicState() async {
    _micStateValue.value = (_micStateValue.value + 1) % 3;

    if (micState == MicState.inProgress) {
      await _startListening();
    } else if (micState == MicState.finish) {
      await _stopListening();
    } else {
      await _getNextQuestion();
    }
  }

  /// STT를 위한 음성 녹음 시작
  Future<void> _startListening() async {
    _currentSpeech.value = '';
    bool available = await _speech.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (errorNotification) => print('onError: $errorNotification'),
    );

    // 빈 말풍선 추가
    int bubbleIndex = chatBubbles.length;
    chatBubbles.add(const ChatBubble(isUser: true, message: ''));

    if (available) {
      await _speech.listen(
        onResult: (result) {
          _currentSpeech.value = result.recognizedWords;

          // 실시간으로 말풍선 업데이트
          chatBubbles[bubbleIndex] = ChatBubble(isUser: true, message: _currentSpeech.value);

          if (result.finalResult) {
            conversations.add(Conversation(
              conversationType: 'HUMAN',
              content: _currentSpeech.value,
            ));
            updateChatBubbles();
            _currentSpeech.value = '';
          }
        },
        localeId: 'ko_KR', // 한국어 설정
      );
    }
  }

  /// STT 종료
  Future<void> _stopListening() async {
    await _speech.stop();
    _currentSpeech.value = '';
  }

  /// Image Picker
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      return;
    }
  }

  Future<void> saveImage() async {
    if (selectedImage.value != null) {
      // TODO: 이미지 업로드 API 호출
      await _apiService.uploadImage(selectedImage.value!);
      selectedImage.value = null;
    }
  }

  void clearSelectedImage() {
    selectedImage.value = null;
  }

  /// 답변 후 다음 질문 받아오기
  Future<void> _getNextQuestion() async {
    try {
      isLoading(true);

      // 현재까지의 대화 내용을 JSON 형태로 변환
      conversations.sort((a, b) => a.timestamp.compareTo(b.timestamp)); // 시간순 정렬
      final conversationsJson = conversations.map((conv) => conv.toJson()).toList();

      final result = await _apiService.getNextQuestion(conversationsJson, predefinedQuestions);

      final String nextQuestion = result['nextQuestion'];
      final bool isPredefined = result['isPredefined'];
      // TODO: isPredefined에 따라 질문이 미리 정해진 경우 처리하여 진행도 계산.

      if (nextQuestion.isNotEmpty) {
        conversations.add(Conversation(
          conversationType: 'AI',
          content: nextQuestion,
        ));
        updateChatBubbles();
      } else {
        // 더 이상 질문이 없는 경우 처리
        Get.snackbar('알림', '모든 질문이 완료되었습니다.');
      }
    } catch (e) {
      Get.snackbar('오류', e.toString());
    } finally {
      isLoading(false);
    }
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
