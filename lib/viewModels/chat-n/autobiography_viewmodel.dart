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
      final result = await service.fetchAutobiography(autobiographyId); // 실제 서비스 호출 부
      // final result = ChatAutobiography(
      //   id: autobiographyId,
      //   title: '첫 기억',
      //   content:
      //   "어린 시절의 기억들은 나의 마음 깊숙이 자리 잡고 있다. 그 중에서도 가장 처음으로 떠오르는 기억은 내가 5살 때 아버지의 차를 타고 할머니 댁에 갔던 날이다. \n\n 그날은 유독 아버지의 히터가 너무 뜨거워서 차 안이 무척 더웠다. 그 기억이 너무 강렬해서 이후로 차를 탈 때 히터가 켜져 있으면 타지 않으려고 했던 것이 아직도 생생하다. 그때의 나는 히터의 뜨거움이 마치 세상의 모든 더위를 압축한 것처럼 느껴졌었다. 이 기억은 나에게 차 안의 히터와 관련된 작은 트라우마를 남겼지만, 동시에 가족과의 소중한 시간을 떠올리게 한다. 아버지와 함께했던 그 시간은 나에게 큰 의미가 있다. 아버지와의 소중한 추억은 나의 첫 기억으로 남아 있다.\n\n어린 시절의 나는 땅따먹기를 가장 좋아했다. 내가 함께 노는 사람들은 나보다 3살은 더 많은 언니 오빠들이었는데, 그들은 내가 어리다고 배려해주면서 내가 질 것 같을 때마다 엄청 봐주면서 이기게 해주었다. 그 놀이는 나에게 배려의 중요성을 가르쳐 주었다. 나보다 나이가 많은 언니 오빠들이 나를 배려해주는 모습을 보면서 나도 다른 사람을 배려하는 법을 배웠다. 그때의 나는 단순히 놀이를 즐기는 것이 아니라, 사람들과의 관계에서 배려와 이해를 배우고 있었다.\n\n가족과의 순간 중 가장 기억에 남는 것은 강원도로 놀러 갔던 때이다. 가족끼리 여행을 간 것이 너무 오랜만이라 가슴이 설레였다. 그때의 나는 가족과 함께하는 시간이 얼마나 소중한지 깨달았다. 가족과 함께하는 시간은 나에게 큰 행복을 주었고, 그 순간들은 나의 마음속에 깊이 새겨져 있다.\n\n어린 시절 가장 좋아했던 음식은 돈가스였다. 어릴 적 어머니 아버지가 맞벌이라서 아파트 1층에 사시는 이웃 할머니 할아버지께 맡겨진 적이 있었는데, 할아버지께서 돈가스 소스를 직접 만드셨다. 그 소스는 어디서도 먹지 못한 특별한 맛이었고, 그래서 나는 돈가스를 좋아하게 되었다. 그 소스의 맛은 아직도 내 입안에 남아 있는 듯하다.\n\n첫 번째 친구는 한채림이라는 아이였다. 나는 항상 무언가를 자랑했고, 그 아이는 나를 부러워해주거나 칭찬해주는 관계였다. 지금 생각해보면 그 친구가 나보다 훨씬 성숙하고 어른스러웠던 것 같다. 그 친구와의 관계는 나에게 많은 것을 가르쳐 주었다.\n\n어릴 때 겪었던 가장 큰 두려움은 물에 빠져 죽을 뻔했던 일이다. 싸이판을 놀러가서 수영장을 갔는데, 내가 수영을 못해서 빠져죽을 뻔했다. 그 이후로 물이 무서웠지만, 시간이 지나면서 자연스럽게 극복하게 되었다. 나는 몸에 열이 많은 편이라 물에 대한 두려움을 점차 잊게 되었다.\n\n유년기 시절 가장 큰 꿈은 대통령이 되는 것이었다. 하지만 여느 어린 아이들처럼 딱히 그 꿈을 위해 노력하지는 않았다. 그저 대통령이 되는 꿈을 꾸며 상상하는 것만으로도 충분히 행복했다.\n\n어린 시절의 학교 생활은 평범했다. 첫 번째로 기억나는 선생님은 김미자 선생님이었다. 중년의 여성분이셨고, 상냥했던 것 정도만 기억난다. 그 외의 기억은 희미하다. 어린 시절의 나는 많은 것을 경험하고 배웠다. 그 시절의 기억들은 나의 마음속에 깊이 새겨져 있으며, 나의 성장에 큰 영향을 미쳤다. 그 시절의 추억들은 나에게 소중한 자산이다."
      //   ,
      //   coverImageUrl: 'assets/images/person_ex.jpg',
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
