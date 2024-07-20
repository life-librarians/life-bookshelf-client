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
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final MyPageApiService apiService = MyPageApiService();
  RxBool isRemindSubscribed = false.obs;

  void toggleSwitch(int index, bool value) {
    if (index >= 0 && index < switches.length) {
      switches[index].value = value;

      updateSwitchStateOnServer(index, switches[index].value);

      print("Switch at index $index set to $value.");
    } else {

      print("Invalid index: $index. No switch updated.");
    }
  }


  Future<void> updateSwitchStateOnServer(int index, bool state) async {
    try {
      // 가정: API 서비스에 updateSwitchState 메서드가 있다고 가정합니다.
      await apiService.updateSwitchState(index, state);
      print("Switch state updated on server for index $index: $state");
    } catch (e) {
      print("Failed to update switch state on server: $e");
    }
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      var fetchedNotifications = await apiService.fetchNotifications();
      notifications.assignAll(fetchedNotifications);
      print("Notifications loaded: ${notifications.length}");
      isRemindSubscribed.value = notifications.any((n) => n.notificationId == 2);
    } catch (e) {
      print("Failed to load notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }
  void toggleSubscription(int notificationId) {
    var currentNotification = notifications.firstWhere((n) => n.notificationId == notificationId, orElse: () => NotificationModel(notificationId: -1, noticeType: '', description: ''));
    if (currentNotification != null) {
      var currentIndex = notifications.indexOf(currentNotification);
      bool isSubscribed = currentNotification.subscribedAt != null;
      notifications[currentIndex] = NotificationModel(
        notificationId: currentNotification.notificationId,
        noticeType: currentNotification.noticeType,
        description: currentNotification.description,
        subscribedAt: isSubscribed ? null : DateTime.now(),
      );
      updateSubscriptions();
    }
  }

  Future<void> updateSubscriptions() async {
    List<int> subscribedIds = notifications.where((n) => n.subscribedAt != null).map((n) => n.notificationId).toList();
    try {
      await apiService.updateNotificationSubscriptions(subscribedIds);
      await fetchNotifications();  // Re-fetch to ensure UI is updated with server state
      print("Notifications updated and refreshed.");
    } catch (e) {
      print("Failed to update notifications: $e");
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

  Future<void> loadBookDetails(int publicationId) async {
    try {
      final result = await apiService.fetchBookDetails(publicationId);
      bookDetail.value = result;
      publishingStatus.value = result.publishStatus!;
      print("Book details loaded for publicationId ID $publicationId: ${bookDetail.value}");
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
    await loadPublishedBooks(1, 10);
    await fetchNotifications();
    isLoading.value = false; // Indicate that data loading is complete.
  }

  @override
  void onInit() {
    super.onInit();
    loadAllData(); // Load all data when initializing.
  }
}


