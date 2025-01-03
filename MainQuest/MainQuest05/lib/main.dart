import 'package:flutter/material.dart';
import 'location.dart'; // 위치 관련 로직 파일 가져오기
import 'play.dart'; // Play 페이지로 이동

void main() {
  runApp(MyApp()); // 앱 실행
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: MainPage(), // 메인 페이지 설정
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState(); // 상태 관리 클래스 생성
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // 애니메이션 컨트롤러 선언
  late Animation<double> _animation; // 크기 변화를 위한 애니메이션 선언

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // 애니메이션 지속 시간 (3초)
      vsync: this, // 애니메이션 생명주기 관리
    )..repeat(reverse: true); // 애니메이션 반복 설정

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
          parent: _controller, curve: Curves.easeInOut), // 부드러운 애니메이션 효과
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 컨트롤러 해제하여 리소스 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기 (MediaQuery 사용)
    final screenWidth = MediaQuery.of(context).size.width; // 화면 너비

    // 아이콘 크기 계산
    final iconSize = screenWidth * 0.5;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/main.png'), // 배경 이미지 설정 (main.png)
                fit: BoxFit.cover, // 화면 크기에 맞게 이미지 조정
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                try {
                  // 위치 데이터 가져오기 (location.dart의 fetchWeatherData 호출)
                  Map<String, dynamic> weatherData =
                      await fetchWeatherData(context);

                  if (weatherData.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlayPage(weatherData: weatherData),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error fetching location or weather data: $e');
                }
              },
              child: ScaleTransition(
                scale: _animation, // 크기 변화 애니메이션 적용
                child: Image.asset(
                  'assets/images/location_icon.png', // location_icon.png 아이콘 이미지 사용
                  width: iconSize, // 아이콘 너비 설정 (화면에 비례)
                  height: iconSize, // 아이콘 높이 설정 (화면에 비례)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
