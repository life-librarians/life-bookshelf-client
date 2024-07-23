import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

enum ImageUploadFolder {
  profileImages,
  bioCoverImages,
  bookCoverImages;

  String get path {
    switch (this) {
      case ImageUploadFolder.profileImages:
        return 'profile-images';
      case ImageUploadFolder.bioCoverImages:
        return 'bio-cover-images';
      case ImageUploadFolder.bookCoverImages:
        return 'book-cover-images';
    }
  }
}

class ImageUploadService extends GetxService {
  final String baseUrl = dotenv.env['API'] ?? "";

  Future<String> getPresignedUrl(File imageFile, ImageUploadFolder folder) async {
    final String fileName = imageFile.path.split('/').last;
    final String randomString = const Uuid().v4();
    final String key = '${folder.path}/$randomString/$fileName';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/images/presigned-url'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'imageUrl': key,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['presignedUrl'] as String;
      } else {
        throw Exception('Failed to get presigned URL. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting presigned URL: $e');
    }
  }

  Future<void> uploadToS3(String presignedUrl, File imageFile) async {
    try {
      final request = http.MultipartRequest('PUT', Uri.parse(presignedUrl));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Successfully uploaded image to S3');
      } else {
        throw Exception('Failed to upload image to S3. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image to S3: $e');
    }
  }

  Future<String> uploadImage(File imageFile, ImageUploadFolder folder) async {
    try {
      final presignedUrl = await getPresignedUrl(imageFile, folder);
      await uploadToS3(presignedUrl, imageFile);
      return presignedUrl;
    } catch (e) {
      throw Exception('Error in image upload process: $e');
    }
  }
}
