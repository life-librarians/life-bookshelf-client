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
  RxList<Map<String, String>> textCorrections = <Map<String, String>>[].obs;
  RxMap<int, bool> correctionStates = <int, bool>{}.obs;

  // 수정 에딧
  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  // 수정 모드 토글
  void toggleFixMode() async {
    isFixMode.value = !isFixMode.value;
    if (!isFixMode.value) {
      await fetchAfterFixContent(autobiography.value!.id);
      isAfterFixMode.value = true;
    }
  }

  // 텍스트 수정 상태 토글
  void toggleCorrectionState(int index) {
    correctionStates[index] = !(correctionStates[index] ?? false);
  }

  // Corrections 업데이트
  void applyCorrections() {
    String updatedContent = contentController.text;
    textCorrections.forEach((correction) {
      String? original = correction['original'];
      String? corrected = correction['corrected'];
      if (original != null && corrected != null) {
        updatedContent = updatedContent.replaceAll(original, corrected);
      }
    });
    contentController.text = updatedContent;
  }

  // 아이디 업데이트
  Future<void> loadAutobiography(int autobiographyId) async {
    isLoading(true);
    try {
      ChatAutobiography fetchedAutobiography = await service.fetchAutobiography(autobiographyId);
      // autobiography.value = fetchedAutobiography;
    } catch (e) {
      errorMessage('Error loading autobiography: $e');
    } finally {
      isLoading(false);
    }
  }

  // 특정 자서전 상세 정보 조회
  Future<void> fetchAutobiography(int autobiographyId) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await service.fetchAutobiography(autobiographyId); // 실제 서비스 호출 부분
      // 더미 데이터
      // final result = ChatAutobiography(
      //   id: autobiographyId,
      //   title: 'Dummy Title',
      //   content:
      //       '나는 김도훈이다. 1985년 3월 15일, 대한민국 서울의 작은 동네에서 태어나 한평생을 꿈을 향해 달려왔다. 이 책은 나의 이야기이다. 꿈을 이루기 위한 여정에서 겪은 도전과 극복, 그리고 소중한 사람들과의 만남을 통해 나는 성장했다. 이 자서전이 당신에게도 용기와 영감을 주길 바란다.\n\n'
      //       '내가 자란 동네는 조용하고 평화로웠다. 부모님은 열심히 일하며 나와 두 명의 여동생을 키우셨다. 아버지는 성실한 공무원이었고, 어머니는 따뜻한 손길로 가정을 돌보는 주부였다. 부모님은 항상 우리에게 꿈을 가지고 도전하라고 가르쳐주셨다.\n'
      //       '어린 시절 나는 호기심이 많고 활발한 아이였다. 학교에서 수학과 과학에 큰 흥미를 느꼈고, 과학자가 되는 꿈을 꾸기 시작했다. 여동생들과의 시간도 소중했다. 우리는 함께 많은 시간을 보내며 서로의 꿈을 응원했다.',
      //   coverImageUrl: 'http://example.com/dummy.jpg',
      //   createdAt: DateTime.now(),
      //   updatedAt: DateTime.now(),
      // );
      autobiography(result);
      contentController.text = result.content ?? '';
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // GPT한테 교정교열 맡기기
  Future<void> fetchAfterFixContent(int autobiographyId) async {
    try {
      isLoading(true);
      errorMessage('');

      // 서버에서 받은 JSON 데이터를 처리하는 부분
      final jsonResponse = await service.proofreadAutobiographyContent(autobiography.value!.id!, contentController.text);

      // jsonResponse에서 corrections라는 key에 해당하는 리스트를 가져옴
      final corrections = (jsonResponse[0]['corrections'] as List<dynamic>).map((correction) => {
        'original': (correction['original'] as String?) ?? '',
        'corrected': (correction['corrected'] as String?) ?? '',
        'explanation': (correction['explanation'] as String?) ?? '',
      }).toList();

      textCorrections.assignAll(corrections);

      for (int i = 0; i < corrections.length; i++) {
        correctionStates[i] = true;
      }
      applyCorrections();
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

      String updatedContent = contentController.text;

      for (int i = 0; i < textCorrections.length; i++) {
        String original = textCorrections[i]["original"]!;
        String corrected = textCorrections[i]["corrected"]!;

        // 사용자가 선택한 상태에 따라 반영
        if (correctionStates[i] == true) {
          updatedContent = updatedContent.replaceAll(original, corrected);
        } else {
          updatedContent = updatedContent.replaceAll(corrected, original);
        }
      }

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
