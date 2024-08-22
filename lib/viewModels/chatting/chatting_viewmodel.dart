import 'package:get/get.dart';
import 'package:life_bookshelf/models/chatting/conversation_model.dart';
import 'package:life_bookshelf/models/home/chapter.dart';
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
  List<dynamic> predefinedQuestions = [];
  int currentQuestionId = 1;

  HomeChapter? currentChapter;

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  bool initialized = false;

  MicState get micState => MicState.fromInt(_micStateValue.value);
  String get currentSpeech => _currentSpeech.value;

  /// 현재 진행 중인 페이지에 들어갈 시 진행 중이던 대화 initializing.
  /// TODO: 페이징 처리
  Future<void> loadConversations(HomeChapter currentChapter, {int page = 1, int size = 20}) async {
    this.currentChapter = currentChapter;
    int chapterId = currentChapter.chapterId;
    try {
      isLoading(true);
      // autobiography 존재하는지 확인
      int? autobiographyId;
      int? interviewId;
      (autobiographyId, interviewId) = await _apiService.checkAutobiography(chapterId);
      // TODO: 없으면 생성 (온보딩에서 생성 시 없을 수 없음) => 추후 온보딩과 함께 수정 필요
      // autobiographyId ??= await _apiService.createAutobiography(currentChapter);
      if (autobiographyId == null || interviewId == null) {
        throw Exception('자서전 생성 실패');
      }

      final loadedConversations = await _apiService.getConversations(autobiographyId, page, size);
      final loadedQuestions = await _apiService.getInterview(interviewId);
      conversations.value = loadedConversations;
      predefinedQuestions = loadedQuestions['results'];
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

    if (chatBubbles.isEmpty) {
      //TODO: 시간 설정 필요
      conversations.add(Conversation(
        conversationType: 'AI',
        content: predefinedQuestions.first['questionText'],
      ));
      chatBubbles.add(ChatBubble(isUser: false, message: predefinedQuestions.first['questionText'], isFinal: true));
      print("첫 질문 업데이트: ${predefinedQuestions.first['questionText']}");
    }
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
      final presignedUrl = await _apiService.uploadImage(selectedImage.value!);
      // TODO: 이미지 업로드 완료 후 자서전 내용 서버에 업로드 (이미지 url과 함께)
      // ~
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
      print(conversationsJson);

      final result = await _apiService.getNextQuestion(conversationsJson, predefinedQuestions, currentChapter!);

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
