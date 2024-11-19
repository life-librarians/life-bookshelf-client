import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/home/autobiography.dart';

class HomeAutobiographyService {
  final String baseUrl;

  HomeAutobiographyService(this.baseUrl);

  Future<List<HomeAutobiography>> fetchAutobiographies() async {
    var url = Uri.parse('$baseUrl/autobiographies');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['results'] is List) {
        return (data['results'] as List)
            .map((autoJson) => HomeAutobiography.fromJson(autoJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected data format: results is not a List');
      }
    } else {
      throw Exception('Failed to load autobiographies');
    }

    // String jsonString = '''
    // {
    //     "results": [
    //         {
    //             "autobiographyId": 1,
    //             "title": "My Early Life",
    //             "contentPreview": "This is the story of my early life...",
    //             "coverImageUrl": "https://i.postimg.cc/SKqL3HL3/example.png",
    //             "createdAt": "2023-01-01T00:00:00Z",
    //             "updatedAt": "2023-01-02T00:00:00Z"
    //         },
    //         {
    //             "autobiographyId": 2,
    //             "title": "My Education",
    //             "contentPreview": "This is the story of my education...",
    //             "coverImageUrl": "https://i.postimg.cc/SKqL3HL3/example.png",
    //             "createdAt": "2023-01-02T00:00:00Z",
    //             "updatedAt": "2023-01-03T00:00:00Z"
    //         }
    //     ]
    // }
    // ''';
    // var data = jsonDecode(jsonString);
    // return (data['results'] as List)
    //     .map((autoJson) => HomeAutobiography.fromJson(autoJson))
    //     .toList();
  }
}
