import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/chat-n/autobiography_model.dart';
import '../../services/chat-n/autobiography_service.dart';

class AutobiographyViewModel extends GetxController {
  final ChatAutobiographyService service;

  AutobiographyViewModel(this.service);

  Rx<ChatAutobiography?> autobiography = Rx<ChatAutobiography?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool isEditing = false.obs;
  TextEditingController contentController = TextEditingController();

  // 상태 관리 변수
  var isFixMode = false.obs;
  var isAfterFixMode = false.obs;

  // Todo: 더미 데이터임. 수정된 텍스트와 원래 텍스트의 매핑
  RxList<Map<String, String>> textCorrections = <Map<String, String>>[
    {"original": "김도훈", "corrected": "도훈 김"},
    {"original": "1985년 3월 15일", "corrected": "March 15, 1985"},
    {"original": "과학자가 되는 꿈", "corrected": "과학자의 꿈"},
  ].obs;

  // 수정된 부분의 상태 관리
  RxMap<int, bool> correctionStates = <int, bool>{}.obs;

  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  // 수정 모드 토글
  void toggleFixMode() {
    isFixMode.value = !isFixMode.value;
    if (isFixMode.value == false) {
      isAfterFixMode.value = true;
    }
  }

  // Todo: 최종 교정교열 하는 로직으로 넘어가는 상태 토글
  void toggleAfterFixMode() {
    isAfterFixMode.value = !isAfterFixMode.value;
  }

  // 텍스트 수정 상태 토글
  void toggleCorrectionState(int index) {
    correctionStates[index] = !(correctionStates[index] ?? false);
  }

  // 특정 자서전 상세 정보 조회
  Future<void> fetchAutobiography(int autobiographyId) async {
    try {
      isLoading(true);
      errorMessage('');

      // Todo API 호출: 서비스를 통해 실제 자서전 데이터 조회
      // final result = await service.fetchAutobiography(autobiographyId); // 실제 서비스 호출 부분

      // 더미 데이터
      final result = ChatAutobiography(
        id: autobiographyId,
        chapterId: 1,
        memberId: 1,
        title: 'Dummy Title',
        content:
            '나는 김도훈이다. 1985년 3월 15일, 대한민국 서울의 작은 동네에서 태어나 한평생을 꿈을 향해 달려왔다. 이 책은 나의 이야기이다. 꿈을 이루기 위한 여정에서 겪은 도전과 극복, 그리고 소중한 사람들과의 만남을 통해 나는 성장했다. 이 자서전이 당신에게도 용기와 영감을 주길 바란다.\n\n'
            '내가 자란 동네는 조용하고 평화로웠다. 부모님은 열심히 일하며 나와 두 명의 여동생을 키우셨다. 아버지는 성실한 공무원이었고, 어머니는 따뜻한 손길로 가정을 돌보는 주부였다. 부모님은 항상 우리에게 꿈을 가지고 도전하라고 가르쳐주셨다.\n'
            '어린 시절 나는 호기심이 많고 활발한 아이였다. 학교에서 수학과 과학에 큰 흥미를 느꼈고, 과학자가 되는 꿈을 꾸기 시작했다. 여동생들과의 시간도 소중했다. 우리는 함께 많은 시간을 보내며 서로의 꿈을 응원했다.',
        contentPreview: '내가 태어났을 때, 나의 가족은 ...',
        coverImageUrl: 'http://example.com/dummy.jpg',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      autobiography(result);
      contentController.text = result.content ?? '';
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Todo: 이거 model 추가 해야됨. 시원님한테 말하기. GPT가 수정한 텍스트 받기
  Future<void> fetchAfterFixContent(int autobiographyId) async {
    try {
      isLoading(true);
      errorMessage('');

      // 더미 데이터: GPT가 수정한 텍스트
      final corrections = [
        {"original": "김도훈", "corrected": "도훈 김"},
        {"original": "1985년 3월 15일", "corrected": "March 15, 1985"},
        {"original": "과학자가 되는 꿈", "corrected": "과학자의 꿈"},
      ];

      textCorrections.assignAll(corrections);
      for (int i = 0; i < corrections.length; i++) {
        correctionStates[i] = true; // 기본적으로 수정된 텍스트가 보이도록 설정
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // 최종적으로 수정된 텍스트를 백엔드로 전송
  Future<void> submitCorrections() async {
    try {
      isLoading(true);
      errorMessage('');

      List<Map<String, String>> selectedCorrections = [];
      for (int i = 0; i < textCorrections.length; i++) {
        if (correctionStates[i] == true) {
          selectedCorrections.add(textCorrections[i]);
        }
      }
      // 현재 내용을 텍스트로 변환
      String updatedContent = contentController.text;
      // 서비스로 백엔드에 전송
      await service.updateAutobiography(
        autobiography.value!.id!,
        autobiography.value!.title!,
        updatedContent,
        autobiography.value!.coverImageUrl!,
      );
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
