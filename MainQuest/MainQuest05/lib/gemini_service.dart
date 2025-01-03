import 'dart:convert'; // JSON 파싱용
import 'package:http/http.dart' as http; // HTTP 요청용

class GeminiService {
  // Gemini 1.5 Flash 모델의 엔드포인트 URL
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta2/models/gemini-1p5-flash:generateText';

  // Gemini 질문을 보내고 응답을 받는 메서드
  static Future<String> askGemini(String prompt) async {
    try {
      // Google Cloud에서 발급받은 API 키 (여기에 실제 API 키 입력)
      const String apiKey =
          'key'; // <-- 여기에 발급받은 API 키 입력

      // HTTP POST 요청 생성
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'), // <-- URL에 API 키를 쿼리 매개변수로 추가
        headers: {
          'Content-Type': 'application/json', // JSON 데이터 전송 헤더
        },
        body: jsonEncode({
          'prompt': {'text': prompt}, // 프롬프트 텍스트
          'temperature': 0.7, // 응답 다양성을 조절하는 매개변수 (선택적)
          'maxOutputTokens': 256 // 최대 출력 토큰 수 (선택적)
        }),
      );

      // 응답 상태 코드 확인
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // JSON 응답 파싱
        return data['candidates']?[0]['output'] ??
            'No response from Gemini.'; // 응답 텍스트 반환
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Gemini 데이터를 가져오지 못했습니다: ${response.statusCode}');
      }
    } catch (e) {
      print('Error communicating with Gemini: $e');
      return '오류가 발생했습니다. 다시 시도해주세요.';
    }
  }
}
