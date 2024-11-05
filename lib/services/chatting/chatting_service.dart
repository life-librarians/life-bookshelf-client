import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:life_bookshelf/models/chatting/conversation_model.dart';
import 'package:life_bookshelf/models/home/chapter.dart';
import 'package:life_bookshelf/services/image_upload_service.dart';
import 'package:life_bookshelf/services/userpreferences_service.dart';

class ChattingService extends GetxService {
  final ImageUploadService _imageUploadService = Get.find<ImageUploadService>();

  final String baseUrl = dotenv.env['API'] ?? "";
  final String aiUrl = dotenv.env['AI'] ?? "";
  String token = UserPreferences.getUserToken();
  final Map<String, dynamic> userInfo = <String, dynamic>{}.obs;

  Future<Map<String, dynamic>> getInterview(int interviewId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/interviews/$interviewId/questions'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = responseData;
        return data;
      } else {
        throw Exception('인터뷰 정보를 불러오는 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('인터뷰 정보를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  Future<Map<String, dynamic>> getChaptersInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/autobiographies/chapters?size=100'), // TODO: 추후 페이징 처리 필요
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('자서전 정보를 불러오는 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  /// Autobiography가 생성되었는 지 확인
  Future<(int?, int?)> checkAutobiography(int chapterId) async {
    // 전체 자서전 목록 조회 후, 해당 chapterId가 있는지 확인
    try {
      final response = await http.get(Uri.parse('$baseUrl/autobiographies'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // 응답 본문을 JSON으로 디코딩
        final Map<String, dynamic> autobiographies = jsonDecode(response.body);

        // 각 자서전을 순회하며 chapterId가 있는지 확인
        for (var autobiography in autobiographies['results']) {
          if (autobiography['chapterId'] == chapterId) {
            // chapterId가 있는 경우 autobiographyId 반환
            int interviewId = autobiography['interviewId'];
            int autobiographyId = autobiography['autobiographyId'];
            return (autobiographyId, interviewId);
          }
        }
        // chapterId를 찾지 못한 경우
        return (null, null);
      }
    } catch (e) {
      throw Exception('자서전 목록 조회 중 오류 발생: $e');
    }
    return (null, null);
  }

  Future<void> saveConversation(List<Conversation> conversations, int interviewId) async {
    print(interviewId);
    try {
      final response = await http.post(Uri.parse('$baseUrl/interviews/$interviewId/conversations'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'conversations': getLastTwo(conversations)
                .map((conv) => {
                      'content': conv.content,
                      'conversationType': conv.conversationType == 'AI' ? 'BOT' : "HUMAN",
                    })
                .toList(),
          }));

      if (response.statusCode == 201) {
        print('대화 저장 성공');
      } else {
        print(utf8.decode(response.bodyBytes));
        throw Exception('대화 저장 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('대화 저장 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> createAutobiography(HomeChapter chapter) async {
    List<String> interviewQuestions = await generateInterviewQuestions(chapter);

    try {
      print('질문 개수: ${interviewQuestions.length}');

      print('요청 본문:');
      print(jsonEncode({
        'title': chapter.chapterName,
        'content': chapter.description,
        'interviewQuestions': interviewQuestions
            .map((question) => {
                  'order': interviewQuestions.indexOf(question) + 1,
                  'questionText': question,
                })
            .toList(),
      }));

      final response = await http.post(Uri.parse('$baseUrl/autobiographies'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'title': chapter.chapterName,
            'content': chapter.description,
            'interviewQuestions': interviewQuestions
                .map((question) => {
                      'order': interviewQuestions.indexOf(question) + 1,
                      'questionText': question.length > 60 ? '${question.substring(0, 60)}...' : question,
                    })
                .toList(),
          }));

      if (response.statusCode == 201) {
        // TODO: 로직 변경으로 인해 주석 처리, 노션 참고
        // if (response.body.isEmpty) {
        //   print('경고: 자서전 생성 성공. 그러나 응답 본문이 비어 있음. - chatting_service.dart, createAutobiography()');
        //   final autobiographyId = await fetchAutobiographyId(chapter);
        //   print('응답 본문이 비어 있어 찾아온 자서전 ID: $autobiographyId');
        //   return autobiographyId;
        // }
        // final Map<String, dynamic> data = json.decode(response.body);
        print('자서전 생성 성공: ${utf8.decode(response.bodyBytes)}');
        // return data['autobiographyId'] as int;
      } else {
        print(utf8.decode(response.bodyBytes));
        throw Exception('자서전 생성 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('자서전 생성 중 오류가 발생했습니다: $e');
    }
  }

  Future<List<String>> generateInterviewQuestions(HomeChapter chapter) async {
    final url = '$aiUrl/interviews/interview-questions';
    await fetchUserInfo();
    final chaptersInfo = await getChaptersInfo();
    Map<String, dynamic> chapterInfo = {};
    Map<String, dynamic> subChapterInfo = {};

    for (var c in chaptersInfo['results']) {
      for (var subChapter in c['subChapters']) {
        if (subChapter['chapterId'] == chapter.chapterId) {
          chapterInfo = {
            'title': chapter.chapterName,
            'description': chapter.description ?? "",
          };
          subChapterInfo = {
            'title': subChapter['chapterName'],
            'description': subChapter['chapterDescription'] ?? "",
          };
          break;
        }
      }
      if (chapterInfo.isNotEmpty) break;
    }
    if (chapterInfo.isEmpty || subChapterInfo.isEmpty) {
      throw Exception('해당 챕터 정보를 찾을 수 없습니다.');
    }

    final body = jsonEncode({
      'user_info': {
        "user_name": userInfo['name'],
        "date_of_birth": userInfo['bornedAt'],
        "gender": userInfo['gender'],
        "has_children": userInfo['hasChildren'],
        // TODO: api 수정 후 다시 추가 (userInfo fetching부터)
        "occupation": "",
        "education_level": "",
        "marital_status": "",
      },
      'chapter_info': {
        'title': chapterInfo['title'],
        'description': chapterInfo['description'],
      },
      'sub_chapter_info': {
        'title': subChapterInfo['title'],
        'description': subChapterInfo['description'],
      }
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        print("성공적으로 인터뷰 질문 생성: $data");
        return List<String>.from(data['interview_questions']);
      } else {
        print(utf8.decode(response.bodyBytes));
        throw Exception('질문 생성 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('질문 생성 중 오류가 발생했습니다: $e');
    }
  }

  // TODO: Pagination에 따른 Paging 구현 필요
  Future<List<Conversation>> getConversations(int interviewId, int page, int size) async {
    try {
      print(token);
      final response = await http.get(Uri.parse('$baseUrl/interviews/$interviewId/conversations?page=$page&size=$size'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> results = data['results'];
        return results
            .map((item) => Conversation(
                  conversationType: item['conversationType'] == 'BOT' ? 'AI' : 'HUMAN',
                  content: item['content'],
                  timestamp: DateTime.parse(item['createdAt']),
                ))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('BIO008: 자서전 ID가 존재하지 않습니다.');
      } else if (response.statusCode == 403) {
        throw Exception('BIO009: 해당 자서전의 주인이 아닙니다.');
      } else {
        throw Exception('서버 오류가 발생했습니다.');
      }
    } catch (e) {
      throw Exception('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  /// 사용자 정보 가져오기
  /// TODO: 추후 유저 정보를 전역에서 받아올 수 있게 되면, 삭제 필요
  Future<void> fetchUserInfo() async {
    if (userInfo.isEmpty) {
      final response = await http.get(Uri.parse('$baseUrl/members/me'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        userInfo['name'] = data['name'];
        userInfo['bornedAt'] = data['bornedAt'];
        userInfo['gender'] = data['gender'];
        userInfo['hasChildren'] = data['hasChildren'];
      } else {
        throw Exception('사용자 정보를 가져오는 데 실패했습니다. 상태 코드: ${response.statusCode}');
      }

      final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      print('응답 데이터: $responseData');
    }
  }

  // TODO: 추후 온보딩 화면에서 받아오는 값으로 변경 필요
  Future<String> getNextQuestion(List<Map<String, dynamic>> conversations, List<dynamic> predefinedQuestions, HomeChapter chapter) async {
    await fetchUserInfo();
    final url = '$aiUrl/interviews/interview-chat';
    //TODO: GenerateInterviewQuestions 함수와 중복되는 부분
    final chaptersInfo = await getChaptersInfo();
    Map<String, dynamic> chapterInfo = {};
    Map<String, dynamic> subChapterInfo = {};

    for (var c in chaptersInfo['results']) {
      for (var subChapter in c['subChapters']) {
        if (subChapter['chapterId'] == chapter.chapterId) {
          chapterInfo = {
            'title': chapter.chapterName,
            'description': chapter.description ?? "",
          };
          subChapterInfo = {
            'title': subChapter['chapterName'],
            'description': subChapter['chapterDescription'] ?? "",
          };
          break;
        }
      }
      if (chapterInfo.isNotEmpty) break;
    }
    if (chapterInfo.isEmpty || subChapterInfo.isEmpty) {
      throw Exception('해당 챕터 정보를 찾을 수 없습니다.');
    }

    final body = jsonEncode({
      'user_info': {
        "user_name": userInfo['name'],
        "date_of_birth": userInfo['bornedAt'],
        "gender": userInfo['gender'],
        "has_children": userInfo['hasChildren'],
        // TODO: api 수정 후 다시 추가 (userInfo fetching부터)
        "occupation": " ",
        "education_level": " ",
        "marital_status": " ",
      },
      'chapter_info': {
        'title': chapterInfo['title'],
        'description': chapterInfo['description'],
      },
      'sub_chapter_info': {
        'title': subChapterInfo['title'],
        'description': subChapterInfo['description'],
      },
      'conversation_history': convertConversationFormat(conversations),
      'current_answer': conversations.last['content'],
      'question_limit': 1
    });

    // print(body);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final String data = utf8.decode(response.bodyBytes);
        print("생성된 질문: $data");
        return data;
      } else {
        print(utf8.decode(response.bodyBytes));
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
      throw Exception('다음 질문을 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  /// presigned URL을 통해 이미지를 S3에 업로드
  Future<String> uploadImage(File imageFile) async {
    return await _imageUploadService.uploadImage(imageFile, ImageUploadFolder.bioCoverImages);
  }

  /// AI 서버 req 형식에 따라 변환
  List<Map<String, dynamic>> convertConversationFormat(List<Map<String, dynamic>> originalList) {
    return originalList.map((item) {
      // conversationType을 conversation_type으로 변환
      String conversationType = item['conversationType'] == 'AI' ? 'BOT' : 'HUMAN';

      // 새로운 형식의 맵 생성
      return {
        'content': item['content'],
        'conversation_type': conversationType,
      };
    }).toList();
  }

  Future<int> fetchAutobiographyId(HomeChapter chapter) async {
    try {
      final autobiographyResponse = await http.get(
        Uri.parse('$baseUrl/autobiographies'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (autobiographyResponse.statusCode == 200) {
        final Map<String, dynamic> autobiographyData = json.decode(autobiographyResponse.body);
        final List<dynamic> results = autobiographyData['results'];

        // chapterId와 일치하는 자서전 찾기
        final matchingAutobiography = results.firstWhere(
          (autobiography) => autobiography['chapterId'] == chapter.chapterId,
          orElse: () => null,
        );

        if (matchingAutobiography != null) {
          return matchingAutobiography['autobiographyId'];
        } else {
          print('경고: 해당 챕터에 대한 자서전을 찾을 수 없습니다.');
          return -1;
        }
      } else {
        print('자서전 정보를 가져오는 데 실패했습니다. 상태 코드: ${autobiographyResponse.statusCode}');
        return -1;
      }
    } catch (e) {
      print('자서전 ID를 가져오는 중 오류 발생: $e');
      return -1;
    }
  }

  /// 인터뷰 질문 index (사전 생성 질문) 다음으로 넘기기
  Future<void> moveToNextQuestionIndex(int interviewId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/interviews/$interviewId/questions/current-question'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('사전 질문 인덱스를 다음으로 이동했습니다.');
      } else {
        print('사전 질문 인덱스를 다음으로 이동하는데 실패했습니다. 상태 코드: ${response.statusCode}');
        throw Exception('다음 질문으로 이동 실패');
      }
    } catch (e) {
      print('사전 질문 인덱스를 다음으로 이동 중 오류 발생: $e');
      throw Exception('다음 질문으로 이동 중 오류 발생');
    }
  }

  /// 최종적으로 자서전 텍스트를 생성
  Future<String> createAutobiographyText(List<Conversation> conversations, int interviewId, HomeChapter chapter) async {
    // 필요한 정보 가져오기
    await fetchUserInfo();
    final chaptersInfo = await getChaptersInfo();
    Map<String, dynamic> chapterInfo = {};
    Map<String, dynamic> subChapterInfo = {};

    // 챕터 정보 찾기
    for (var c in chaptersInfo['results']) {
      for (var subChapter in c['subChapters']) {
        if (subChapter['chapterId'] == chapter.chapterId) {
          chapterInfo = {
            'title': chapter.chapterName,
            'description': chapter.description ?? "",
          };
          subChapterInfo = {
            'title': subChapter['chapterName'],
            'description': subChapter['chapterDescription'] ?? "",
          };
          break;
        }
      }
      if (chapterInfo.isNotEmpty) break;
    }

    // 대화 내용을 API 형식에 맞게 변환
    final List<Map<String, dynamic>> formattedConversations = conversations
        .map((conv) => {
              'content': conv.content,
              'conversation_type': conv.conversationType == 'AI' ? 'BOT' : 'HUMAN',
            })
        .toList();

    final body = jsonEncode({
      'user_info': {
        "user_name": userInfo['name'],
        "date_of_birth": userInfo['bornedAt'],
        "gender": userInfo['gender'],
        "has_children": userInfo['hasChildren'],
        "occupation": " ",
        "education_level": " ",
        "marital_status": " ",
      },
      'chapter_info': chapterInfo,
      'sub_chapter_info': subChapterInfo,
      'interviews': formattedConversations,
    });

    try {
      final response = await http.post(
        Uri.parse('$aiUrl/autobiographies/generate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data['autobiographical_text'];
      } else {
        print(utf8.decode(response.bodyBytes));
        throw Exception('자서전 텍스트 생성 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('자서전 텍스트 생성 중 오류가 발생했습니다: $e');
    }
  }

  /// 자서전 내용 확정
  Future<void> finishAutobiography(int autobiographyId, HomeChapter chapter, String autobiographyText, String preSignedImageUrl) async {
    try {
      // 요청 본문 구성
      final Map<String, dynamic> requestBody = {
        'title': chapter.chapterName,
        'content': autobiographyText,
        'preSignedCoverImageUrl': preSignedImageUrl,
      };

      // POST 요청 보내기
      final response = await http.post(
        Uri.parse('$baseUrl/autobiographies/$autobiographyId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('자서전 수정(확정)이 성공적으로 완료되었습니다.');
      } else {
        print(utf8.decode(response.bodyBytes));
        throw Exception('자서전 완료 중 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('자서전 완료 중 오류가 발생했습니다: $e');
    }
  }
}

List<T> getLastTwo<T>(List<T> list) {
  if (list.length < 2) {
    return List.from(list); // 리스트의 모든 요소 반환 (0개 또는 1개)
  }
  return list.sublist(list.length - 2);
}
