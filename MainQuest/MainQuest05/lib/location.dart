import 'package:geolocator/geolocator.dart'; // 위치 정보를 가져오기 위한 패키지
import 'package:flutter/material.dart'; // Flutter UI 라이브러리
import 'weather_service.dart'; // 날씨 데이터를 가져오는 서비스

// 위치 데이터를 가져오고 날씨 데이터를 반환하는 함수
Future<Map<String, dynamic>> fetchWeatherData(BuildContext context) async {
  try {
    // 위치 서비스 활성화 여부 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('위치 서비스가 비활성화되어 있습니다.');
    }

    // 위치 권한 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('위치 권한이 영구적으로 거부되었습니다.');
    }

    // LocationSettings 객체를 명시적으로 정의
    final locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, // 높은 정확도로 위치 요청
      distanceFilter: 100, // 최소 거리 변화 (미터 단위)
    );

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings, // 정의한 LocationSettings 전달
    );

    print('현재 위치: ${position.latitude}, ${position.longitude}'); // 디버깅용 로그

    // 날씨 데이터 가져오기
    Map<String, dynamic> weatherData = await WeatherService.getWeatherData(
      position.latitude,
      position.longitude,
    );

    return weatherData; // 날씨 데이터를 반환합니다.
  } catch (e) {
    print('Error fetching location or weather data: $e'); // 오류 로그 출력

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('위치를 가져올 수 없습니다.')),
    );

    return {}; // 오류 발생 시 빈 데이터를 반환합니다.
  }
}
