import 'package:get/get.dart';
import 'package:life_bookshelf/models/mypage/mypage_model.dart';
import 'package:life_bookshelf/services/mypage/mypage_service.dart';

import '../../views/login/login_screen.dart';

class MypageViewModel extends GetxController {
  List<RxBool> switches = List.generate(6, (_) => false.obs);

  Rx<MyPageUserModel?> userModel = Rx<MyPageUserModel?>(null);
  // Additional Rx properties for books
  Rx<BookDetailModel?> bookDetail = Rx<BookDetailModel?>(null);
  Rx<BookListModel?> bookList = Rx<BookListModel?>(null);
  Rx<int?> latestPublicationId = Rx<int?>(null);
  RxBool isLoading = true.obs; // 로딩 상태 관리
  RxString publishingStatus = 'PUBLISHED'.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final MyPageApiService apiService = MyPageApiService();
  RxBool isRemindSubscribed = false.obs;

  // FCM 토큰을 저장하는 변수
  RxString deviceToken = ''.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadAllData(); // Load all data when initializing.
  //   _initializeFCMToken(); // FCM 토큰 초기화
  // }
  //
  // // FCM 토큰을 가져와서 deviceToken 변수에 저장하는 메서드
  // Future<void> _initializeFCMToken() async {
  //   try {
  //     deviceToken.value = await FirebaseMessaging.instance.getToken() ?? '';
  //     print("FCM Device Token: ${deviceToken.value}");
  //   } catch (e) {
  //     print("Failed to get FCM token: $e");
  //   }
  // }

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

  // 알림 구독 상태를 서버에 업데이트하면서 FCM 토큰을 전달하는 메서드
  // Future<void> updateSubscriptions() async {
  //   List<int> subscribedIds = notifications
  //       .where((n) => n.subscribedAt != null)
  //       .map((n) => n.notificationId)
  //       .toList();
  //   try {
  //     await apiService.updateNotificationSubscriptions(
  //       subscribedIds,
  //       deviceToken.value, // FCM 디바이스 토큰 전달
  //     );
  //     await fetchNotifications();  // Re-fetch to ensure UI is updated with server state
  //     print("Notifications updated and refreshed.");
  //   } catch (e) {
  //     print("Failed to update notifications: $e");
  //   }
  // }

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
      if (result.publishStatus != null) {
        print("Publishing status updated to: ${result.publishStatus}");
        publishingStatus.value = result.publishStatus!;
      }
    } catch (e) {
      print("Failed to load book details: $e");
      // 404 에러인 경우 NOT_PUBLISHED 상태로 설정
      if (e.toString().contains('PUB001') || e.toString().contains('404')) {
        publishingStatus.value = 'NOT_PUBLISHED';
        print("Publishing status set to NOT_PUBLISHED due to PUB001 error");
      }
    }
  }

  Future<void> loadPublishedBooks(int page, int size) async {
    try {
      final result = await apiService.fetchPublishedBooks(page, size);
      bookList.value = result;
      print("Book list loaded: ${bookList.value}");
      print("Results: ${bookList.value?.results}");  // 결과 배열의 내용 확인
      print("Results length: ${bookList.value?.results?.length}");  // 결과 배열의 길이 확인
    } catch (e) {
      print("Failed to load published books: $e");
    }
  }

  Future<void> loadAllData() async {
    print("Starting loadAllData..."); // 시작 로그
    isLoading.value = true;
    try {
      print("Loading user profile..."); // 각 단계별 로그
      await loadUserProfile();

      print("Loading published books...");
      await loadPublishedBooks(0, 10);

      if (bookList.value != null &&
          bookList.value!.results != null &&
          bookList.value!.results!.isNotEmpty) {
        int firstPublicationId = bookList.value!.results![0].publicationId!;
        print("Loading book details for publicationId: $firstPublicationId");
        await loadBookDetails(firstPublicationId);
        latestPublicationId.value = firstPublicationId;
      } else {
        publishingStatus.value = 'NOT_PUBLISHED';
        print("No published books found");
      }

      print("Loading notifications...");
      await fetchNotifications();

    } catch (e) {
      print("Error in loadAllData: $e");
    } finally {
      isLoading.value = false;
      print("Finished loadAllData"); // 종료 로그
    }
  }

  // 회원 탈퇴 시 호출되는 메서드
  Future<void> deleteUser() async {
    try {
      // FCM 토큰 삭제 로직
      // await FirebaseMessaging.instance.deleteToken();
      // print("FCM 토큰이 삭제되었습니다."); // FCM 토큰 삭제 확인 로그

      final result = await apiService.deleteUser();
      print("회원 탈퇴가 되었습니다.");
      Get.to(LoginScreen());
    } catch (e) {
      print("Failed to delete User: $e");
    }
  }

  @override
  void onInit() {
    print("MypageViewModel onInit called"); // onInit 실행 확인
    super.onInit();
    print("Starting loadAllData from onInit"); // loadAllData 호출 직전
    loadAllData();
    print("loadAllData called from onInit"); // loadAllData 호출 직후
  }
}



