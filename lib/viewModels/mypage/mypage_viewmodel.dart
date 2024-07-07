import 'package:get/get.dart';
import 'package:life_bookshelf/models/mypage/mypage_model.dart';
import 'package:life_bookshelf/services/mypage/mypage_service.dart';

class MypageViewModel extends GetxController {
  List<RxBool> switches = List.generate(6, (_) => false.obs);

  Rx<MyPageUserModel?> userModel = Rx<MyPageUserModel?>(null);
  Rx<List<MyPagePublicationModel>> publications = Rx<List<MyPagePublicationModel>>([]);
  Rx<int?> latestPublicationId = Rx<int?>(null);
  RxBool isLoading = true.obs; // 로딩 상태 관리
  RxString publishingStatus = 'rejected'.obs;

  final MyPageApiService apiService = MyPageApiService();

  void toggleSwitch(int index, bool value) {
    if (index < switches.length) {
      switches[index].value = value;
      print("Switch $index toggled to: ${switches[index].value}");
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final result = await apiService.fetchUserProfile();
      userModel.value = result;
      print("User profile loaded: ${userModel.value}");
    } catch (e) {
      print("Failed to load user profile: $e");
    }
  }

  Future<void> loadPublications(int publicationId) async {
    int currentPage = 1;
    bool hasMore = true;
    List<MyPagePublicationModel> allPublications = [];

    try {
      while (hasMore) {
        final response = await apiService.fetchMyPublications(currentPage, 10);
        allPublications.addAll(response.results.map((pub) => MyPagePublicationModel.fromJson(pub as Map<String, dynamic>)).toList());

        hasMore = response.hasNextPage;
        if (hasMore) currentPage++;
      }

      publications.value = allPublications;
      print("All publications loaded: ${publications.value.length} items");
    } catch (e) {
      print("Failed to load publications: $e");
    }
  }

  Future<void> fetchMostRecentPublication() async {
    try {
      final response = await apiService.fetchMyPublications(1, 1);
      if (response.results.isNotEmpty) {
        latestPublicationId.value = response.results.first.publicationId;
        print("Most recent publication ID: ${latestPublicationId.value}");
        await loadPublications(latestPublicationId.value!);
      }
    } catch (e) {
      print("Failed to fetch most recent publication: $e");
    }
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    await fetchMostRecentPublication();
    await loadUserProfile();
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    loadAllData(); // 모든 데이터를 로딩하는 메서드
  }
}
