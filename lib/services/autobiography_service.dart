import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/autobiography.dart';

class AutobiographyService {
  final String baseUrl;

  AutobiographyService(this.baseUrl);

  Future<List<Autobiography>> fetchAutobiographies(int chapterId) async {
    var url = Uri.parse('$baseUrl/autobiographies/$chapterId');
    var response = await http.get(url);
    /* Uncomment this block to use real API
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return (data['results'] as List)
          .map((autoJson) => Autobiography.fromJson(autoJson))
          .toList();
    } else {
      throw Exception('Failed to load autobiographies');
    }
    */

    String jsonString = '''
    {
        "results": [
            {
                "autobiographyId": 1,
                "title": "My Early Life",
                "contentPreview": "This is the story of my early life...",
                "coverImageUrl": "http://example.com/image1.jpg",
                "createdAt": "2023-01-01T00:00:00Z",
                "updatedAt": "2023-01-02T00:00:00Z"
            },
            {
                "autobiographyId": 2,
                "title": "My Education",
                "contentPreview": "This is the story of my education...",
                "coverImageUrl": "http://example.com/image2.jpg",
                "createdAt": "2023-01-02T00:00:00Z",
                "updatedAt": "2023-01-03T00:00:00Z"
            }
        ]
    }
    ''';
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    var data = jsonDecode(jsonString);
    return (data['results'] as List)
        .map((autoJson) => Autobiography.fromJson(autoJson))
        .toList();
  }
}
