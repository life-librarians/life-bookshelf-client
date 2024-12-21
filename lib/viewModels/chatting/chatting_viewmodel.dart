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
  final RxBool isInterviewFinished = false.obs;
  final String dummyUserPrompt = '''만약 이 메시지가 유저의 답변으로 전달되었다면, 유저 데이터, 챕터 정보, 대화의 전후 맥락을 활용하여 유저의 답변을 임의로 생성하고, 그 답변을 다음에 네가 할 질문 앞에 포함하여 다음 질문을 생성해줘.
예를 들면, 너에게 주어진 데이터가 (AI: [질문], 유저 답변: [이 프롬프트])와 같다면, 네가 생성할 문자열은 "<[임의로 생성한 유저 답변]> [다음으로 생성한 질문]"이 되는 거야.
예시를 들어 줄게. 
    {AI: "가장 인상깊었던 일이 있던 학년은 몇학년인가요?", User: "[이 프롬프트]"}
    와 같은 데이터가 주어지면, 아래와 같이 유저의 답변과 다음 질문을 생성하여 string을 반환해.
    "<가장 인상깊었던 학년은 3학년이야> 그렇다면, 그 일은 무엇이였나요?"
    추가로, 이 프롬프트가 답변으로 전달되었다면, 이전 질문 데이터의 <> 안에 있는 메시지가 이전 유저의 데이터라는 것을 유념하여 이전 대화의 맥락으로 사용하면 돼.''';

  // 사전에 생성한 질문 리스트 (예시)
  List<String> predefinedQuestions = [];
  int currentPredefinedQuestionIndex = 0;
  int additionalQuestionCount = 0;
  int currentQuestionId = 1;

  HomeChapter? currentChapter;

  int? autobiographyId;
  int? interviewId;

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  bool initialized = false;

  MicState get micState => MicState.fromInt(_micStateValue.value);
  String get currentSpeech => _currentSpeech.value;

  /// 현재 진행 중인 페이지에 들어갈 시 진행 중이던 대화 initializing.
  /// TODO: 페이징 처리
  Future<void> loadConversations(HomeChapter currentChapter, {int page = 0, int size = 40}) async {
    this.currentChapter = currentChapter;
    int chapterId = currentChapter.chapterId;
    try {
      isLoading(true);
      // autobiography 존재하는지 확인 후 id 저장
      int? autoid, intid;
      // print(chapterId);
      (autoid, intid) = await _apiService.checkAutobiography(chapterId);
      autobiographyId = autoid;
      interviewId = intid;

      // autobiography 존재하지 않으면 생성 후 다시 체크
      if (autoid == null) {
        // 이전 챕터의 대화 기록 초기화
        conversations.value = <Conversation>[];
        predefinedQuestions = [];
        updateChatBubbles();
        // Autobiography 생성 및 id fetching
        await _apiService.createAutobiography(currentChapter);
        (autoid, intid) = await _apiService.checkAutobiography(chapterId);
        autobiographyId = autoid;
        interviewId = intid;
      }

      if (autobiographyId == null || interviewId == null) {
        throw Exception('자서전 생성 실패');
      }

      final loadedConversations = await _apiService.getConversations(interviewId!, page, size);
      final loadedQuestions = await _apiService.getInterview(interviewId!);
      conversations.value = loadedConversations;
      predefinedQuestions = loadedQuestions['results'].map<String>((q) => q['questionText'] as String).toList();
      currentPredefinedQuestionIndex = loadedQuestions['currentQuestionId'] - loadedQuestions['results'][0]['questionId'];

      final aiQuestionCount = conversations.where((conv) => conv.conversationType == 'AI').length;
      additionalQuestionCount = (aiQuestionCount == 0) ? 0 : (aiQuestionCount - 1) % 3; // 추가질문 개수 - 질문의 개수에서 3을 나누어 나머지로 할당
      print('현재 사전질문 인덱스: $currentPredefinedQuestionIndex');
      print('현재 추가질문 개수: $additionalQuestionCount');
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

    if (chatBubbles.isEmpty && predefinedQuestions.isNotEmpty) {
      conversations.add(Conversation(
        conversationType: 'AI',
        content: predefinedQuestions.first,
      ));
      chatBubbles.add(ChatBubble(isUser: false, message: predefinedQuestions.first, isFinal: true));
      currentPredefinedQuestionIndex++; // 사전 정의 질문 카운트 up
      saveChatBubbles();
      print("첫 질문 업데이트: ${predefinedQuestions.first}");
    }
  }

  void saveChatBubbles() async {
    // API를 통해 서버에 대화 내용 저장
    await _apiService.saveConversation(conversations, interviewId!);
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
    chatBubbles.add(const ChatBubble(isUser: true, message: ""));

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

  /// save Image 및 자서전 텍스트 생성을 통한 자서전 내용 확정
  Future<void> finishInterview() async {
    String? presignedUrl;
    if (selectedImage.value != null) {
      presignedUrl = await _apiService.uploadImage(selectedImage.value!);
    }
    final String autobiographyText = await generateAutobiographyText();
    await _apiService.finishAutobiography(autobiographyId!, currentChapter!, autobiographyText, presignedUrl ?? "");
    // 다음 챕터 갱신 요청
    await _apiService.turnOverChapter();
    selectedImage.value = null;
  }

  void clearSelectedImage() {
    selectedImage.value = null;
  }

  /// 답변 후 다음 질문 받아오기
  Future<void> _getNextQuestion() async {
    try {
      isLoading(true);

      conversations.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      final conversationsJson = conversations.map((conv) => conv.toJson()).toList();

      String nextQuestion;

      if (additionalQuestionCount < 2) {
        // 사용자 정의 질문 생성
        print("질문 생성, 추가 질문 count = $additionalQuestionCount");
        final result = await _apiService.getNextQuestion(conversationsJson, predefinedQuestions, currentChapter!);
        nextQuestion = result;
        additionalQuestionCount++; // 미리 준비한 질문 1개당 2개를 추가 질문 할 수 있도록
      } else {
        print("질문 리스트 사용, 질문 index = $currentPredefinedQuestionIndex");
        // 미리 정의된 질문 사용
        //! 사전 생성 질문 개수 10개로 줄인 부분. 개수 조정 가능
        // if (currentPredefinedQuestionIndex + 1 < predefinedQuestions.length) {
        if (currentPredefinedQuestionIndex + 1 < 2) {
          currentPredefinedQuestionIndex++;
          nextQuestion = predefinedQuestions[currentPredefinedQuestionIndex];
          additionalQuestionCount = 0;
          _apiService.moveToNextQuestionIndex(interviewId!);
        } else {
          // 모든 질문이 끝난 경우
          isInterviewFinished.value = true;
          // isLoading(true);
          Get.snackbar('알림', '모든 질문이 완료되었습니다.');
          return;
        }
      }

      if (nextQuestion.isNotEmpty) {
        conversations.add(Conversation(
          conversationType: 'AI',
          content: nextQuestion,
        ));
        updateChatBubbles();
        saveChatBubbles();
      }
    } catch (e) {
      Get.snackbar('오류', e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// 더미 프롬프트를 사용하여 대화를 이어나가는 함수
  Future<void> sendDummyPrompt() async {
    // 빈 말풍선 추가
    int bubbleIndex = chatBubbles.length;
    chatBubbles.add(const ChatBubble(isUser: true, message: ""));

    // 더미 프롬프트를 현재 speech 값으로 설정
    _currentSpeech.value = dummyUserPrompt;

    // 말풍선 업데이트
    chatBubbles[bubbleIndex] = ChatBubble(isUser: true, message: _currentSpeech.value);

    // 대화 목록에 추가
    conversations.add(Conversation(
      conversationType: 'HUMAN',
      content: _currentSpeech.value,
    ));

    // 채팅 화면 업데이트 및 저장
    updateChatBubbles();
    _currentSpeech.value = '';
    await _getNextQuestion();
  }

  /// 자서전 텍스트 생성
  Future<String> generateAutobiographyText() async {
    try {
      if (interviewId == null || currentChapter == null) {
        throw Exception('인터뷰 ID 또는 챕터 정보가 없습니다.');
      }

      final autobiographyText = await _apiService.createAutobiographyText(conversations, interviewId!, currentChapter!);
      print(autobiographyText);
      return autobiographyText;
    } catch (e) {
      Get.snackbar('오류', '자서전 텍스트 생성 중 오류가 발생했습니다: $e');
      rethrow;
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
