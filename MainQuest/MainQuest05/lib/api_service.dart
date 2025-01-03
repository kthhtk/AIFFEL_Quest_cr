import 'dart:convert'; // JSON 파싱용
import 'package:flutter/services.dart'; // rootBundle 사용

class ApiService {
  // JSON 파일에서 특정 API 키를 로드하는 메서드
  static Future<String> loadApiKey(String keyName) async {
    try {
      // assets/api_keys.json 파일 읽기
      final String jsonString =
          await rootBundle.loadString('assets/api_keys.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString); // JSON 파싱
      if (!jsonData.containsKey(keyName)) {
        throw Exception('API 키가 JSON 파일에 없습니다: $keyName');
      }
      return jsonData[keyName]; // 요청된 키 반환
    } catch (e) {
      throw Exception('API 키를 로드할 수 없습니다: $e'); // 오류 처리
    }
  }
}
