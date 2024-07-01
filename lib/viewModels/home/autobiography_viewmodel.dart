import 'package:get/get.dart';
import '../../models/home/autobiography_model.dart';
import '../../services/home/autobiography_service.dart';

class AutobiographyViewModel extends GetxController {
  final AutobiographyService service;

  AutobiographyViewModel(this.service);

  Rx<Autobiography?> autobiography = Rx<Autobiography?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // 특정 자서전 상세 정보 조회
  Future<void> fetchAutobiography(int autobiographyId) async {
    try {
      isLoading(true);
      errorMessage('');

      // Todo: 실제 API 호출 부분
      // final result = await service.fetchAutobiography(autobiographyId);

      // 더미 데이터
      final result = Autobiography(
        id: autobiographyId,
        chapterId: 1,
        memberId: 1,
        title: 'Dummy Title',
        content: '중학교에 들어가면서 나는 수학에 흥미를 느끼기 시작했다. 수학 선생님이셨던 김 선생님은 나의 멘토가 되셨고, 나는 그분을 통해 수학의 아름다움을 발견했다. 밤늦게까지 문제를 풀면서 느끼는 성취감은 말로 표현할 수 없었다. 그렇게 나는 수학에 대한 열정을 키우며 고등학교에 진학했다.',
        contentPreview: '내가 태어났을 때, 나의 가족은 ...',
        coverImageUrl: 'http://example.com/dummy.jpg',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      autobiography(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
