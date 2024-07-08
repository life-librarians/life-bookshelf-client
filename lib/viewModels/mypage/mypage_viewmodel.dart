import 'package:get/get.dart';
import 'package:life_bookshelf/models/mypage/mypage_model.dart';
import 'package:life_bookshelf/services/mypage/mypage_service.dart';

class MypageViewModel extends GetxController {
  List<RxBool> switches = List.generate(6, (_) => false.obs);

  Rx<MyPageUserModel?> userModel = Rx<MyPageUserModel?>(null);
  // Additional Rx properties for books
  Rx<BookDetailModel?> bookDetail = Rx<BookDetailModel?>(null);
  Rx<BookListModel?> bookList = Rx<BookListModel?>(null);

  Rx<int?> latestPublicationId = Rx<int?>(null);
  RxBool isLoading = true.obs; // 로딩 상태 관리
  RxString publishingStatus = 'IN_PUBLISHING'.obs;

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

  Future<void> loadBookDetails(int memberId) async {
    try {
      final result = await apiService.fetchBookDetails(memberId);
      bookDetail.value = result;
      publishingStatus.value = result.publishStatus!;
      print("Book details loaded for member ID $memberId: ${bookDetail.value}");
    } catch (e) {
      print("Failed to load book details: $e");
    }
  }

  Future<void> loadPublishedBooks(int page, int size) async {
    try {
      final result = await apiService.fetchPublishedBooks(page, size);
      bookList.value = result;
      print("Book list loaded: ${bookList.value}");
    } catch (e) {
      print("Failed to load published books: $e");
    }
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    await loadUserProfile();
    // Example: Load book details for a specific member ID and books list with pagination
    await loadBookDetails(123); // Assuming 123 is a sample member ID
    await loadPublishedBooks(1, 10); // Load the first page with 10 entries per page
    isLoading.value = false; // Indicate that data loading is complete.
  }

  @override
  void onInit() {
    super.onInit();
    loadAllData(); // Load all data when initializing.
  }
}


