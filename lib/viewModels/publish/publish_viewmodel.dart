import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PublishViewModel extends GetxController {
  final RxString bookTitle = ''.obs;
  final RxString titleLocation = '상단'.obs;
  final Rx<XFile?> coverImage = Rx<XFile?>(null);

  void setBookTitle(String title) {
    bookTitle.value = title;
  }

  void setTitleLocation(String location) {
    titleLocation.value = location;
  }

  Future<void> pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        coverImage.value = image;
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void proceedPublication() {
    // TODO: 출판 로직 구현
    print('Publishing book: ${bookTitle.value}');
    print('Title location: ${titleLocation.value}');
    print('Cover image: ${coverImage.value?.path ?? "No image selected"}');
  }
}
