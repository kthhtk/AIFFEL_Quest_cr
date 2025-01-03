import 'package:flutter/material.dart';
import 'dart:async'; // 타이머를 사용하기 위한 패키지
import 'test.dart'; // TestPage 가져오기
import 'gemini_service.dart';

class PlayPage extends StatefulWidget {
  final Map<String, dynamic> weatherData; // 전달받은 날씨 데이터

  PlayPage({required this.weatherData});

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late Map<String, dynamic> weatherData; // 날씨 데이터를 저장할 변수
  late Timer _timer; // 1분마다 리로드를 위한 타이머

  @override
  void initState() {
    super.initState();
    weatherData = widget.weatherData; // 초기 날씨 데이터를 설정
    _startAutoReload(); // 자동 리로드 시작
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머 해제
    super.dispose();
  }

  // 1분마다 데이터를 리로드하는 함수
  void _startAutoReload() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      setState(() {}); // 화면 갱신
    });
  }

  @override
  Widget build(BuildContext context) {
    final int temperature = weatherData['temperature'] ?? 0; // 온도 데이터
    final String city = weatherData['city'] ?? 'Unknown'; // 도시명 데이터
    final String weather = weatherData['weather'] ?? 'Unknown'; // 날씨 상태 데이터
    final String time = weatherData['time'] ?? ''; // 시간 데이터

    // 화면 크기 가져오기 (MediaQuery 사용)
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 텍스트 크기 계산 (화면 크기에 비례)
    final double titleFontSize = screenWidth * 0.08; // 상단 큰 텍스트 크기
    final double subtitleFontSize = screenWidth * 0.05; // 상단 작은 텍스트 크기

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지 설정
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/${_getBackgroundImage(weather)}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 상단 텍스트 표시 (온도, 도시명, 시간)
          Positioned(
            top: screenHeight * 0.05, // 화면 높이에 비례한 위치 설정 (5% 아래)
            left: screenWidth * 0.05, // 화면 너비에 비례한 위치 설정 (5% 오른쪽)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$temperature°', // 온도 표시
                  style: TextStyle(
                    fontSize: titleFontSize, // 동적 폰트 크기 설정
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Roboto', // 폰트 설정 (예시)
                  ),
                ),
                Text(
                  city, // 도시명 표시
                  style: TextStyle(
                    fontSize: subtitleFontSize, // 동적 폰트 크기 설정
                    color: Colors.white,
                    fontFamily: 'Roboto', // 폰트 설정 (예시)
                  ),
                ),
                Text(
                  time, // 시간 표시
                  style: TextStyle(
                    fontSize: subtitleFontSize * 0.8, // 작은 텍스트 크기 설정
                    color: Colors.white,
                    fontFamily: 'Roboto', // 폰트 설정 (예시)
                  ),
                ),
              ],
            ),
          ),
          // 좌측 하단 여성 이미지 추가 (크기 조절, 위치 고정)
          Positioned(
            bottom: screenHeight * 0.01,
            left: screenWidth * 0.0,
            child: SizedBox(
              width: screenWidth * 0.7,
              height: screenHeight * 0.7,
              child: Image.asset(
                _getWomanImage(weatherData['temperature']),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 우측 상단 로케이션 버튼 추가 및 테스트 버튼 추가
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.05,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print("Location button tapped!");
                  },
                  child: Image.asset(
                    'assets/images/location_icon.png',
                    width: screenWidth * 0.1,
                    height: screenHeight * 0.1,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // 간격 추가

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TestPage(onApply: (weather, temperature) {
                                setState(() {
                                  weatherData['weather'] = weather;
                                  weatherData['temperature'] = temperature;
                                });
                              })),
                    );
                  },
                  child: Icon(Icons.settings,
                      size: screenWidth * 0.08, color: Colors.white),
                ),
              ],
            ),
          ),

          // 하단 중앙 텍스트 박스 추가 (Gemini 응답)
          Positioned(
            bottom: screenHeight * 0.02,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: FutureBuilder<String>(
              future: GeminiService.askGemini(
                  '${weatherData['temperature']}도 옷차림 간략히'),
              builder: (context, snapshot) {
                String displayText;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  displayText = "데이터를 불러오는 중입니다...";
                } else if (snapshot.hasError) {
                  displayText = "오류가 발생했습니다. 다시 시도해주세요.";
                } else {
                  displayText = snapshot.data ?? "결과를 가져올 수 없습니다.";
                }

                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      displayText,
                      style: TextStyle(
                        fontSize: subtitleFontSize * 0.8,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String _getBackgroundImage(String weather) {
    switch (weather.toLowerCase()) {
      case '맑음':
        return 'clear.png';
      case '흐림':
        return 'cloud.png';
      case '비':
        return 'rain.png';
      case '눈':
        return 'snow.png';
      default:
        return 'cloud.png';
    }
  }

  String _getWomanImage(int temperature) {
    if (temperature <= 4) return 'assets/images/0-4.png';
    if (temperature <= 9) return 'assets/images/5-9.png';
    if (temperature <= 14) return 'assets/images/10-14.png';
    return 'assets/images/15-20.png';
  }
}
