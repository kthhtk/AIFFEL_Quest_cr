import 'dart:convert'; // JSON 파싱용
import 'package:http/http.dart' as http; // HTTP 요청용
import 'api_service.dart'; // API 키 로드용

class WeatherService {
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // 날씨 데이터를 가져오는 메서드
  static Future<Map<String, dynamic>> getWeatherData(
      double latitude, double longitude) async {
    try {
      final apiKey =
          await ApiService.loadApiKey('openweathermap_api_key'); // API 키 로드

      final url = Uri.parse(
        '$_baseUrl?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {
          'weather': _mapWeatherCondition(data['weather'][0]['main']),
          'temperature': data['main']['temp'].round(),
          'city': data['name'],
          'time': _formatTime(DateTime.now()), // 시간 포맷 적용
        };
      } else if (response.statusCode == 401) {
        throw Exception('유효하지 않은 OpenWeatherMap API 키입니다.');
      } else {
        throw Exception('날씨 데이터를 가져오지 못했습니다: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  static String _mapWeatherCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '맑음';
      case 'clouds':
        return '흐림';
      case 'rain':
        return '비';
      case 'snow':
        return '눈';
      default:
        return '흐림'; // 기본값
    }
  }

  // 시간을 포맷팅하는 메서드 (밀리초 제거, 년도 포함)
  static String _formatTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
