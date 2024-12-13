
// Material Design 위젯을 사용하기 위한 Flutter의 기본 패키지입니다.
// 앱의 디자인과 기본 위젯들을 제공합니다.
import 'package:flutter/material.dart';

// Timer 클래스를 포함하는 비동기 처리를 위한 패키지입니다.
// 주기적인 작업이나 지연 작업을 처리할 수 있게 해줍니다.
import 'dart:async';

// 앱의 시작점입니다.
// runApp 함수는 위젯 트리의 루트를 구성하고 앱을 실행합니다.
void main() {
  runApp(const MyApp());
}

// 앱의 최상위 위젯입니다.
// StatelessWidget은 상태가 변하지 않는 정적인 위젯입니다.
class MyApp extends StatelessWidget {
  // 생성자: const로 선언하여 컴파일 타임에 상수로 처리됩니다.
  // super.key는 위젯 식별을 위한 키값을 상위 클래스로 전달합니다.
  const MyApp({super.key});

  // build 메서드는 위젯의 UI를 구성합니다.
  // BuildContext는 위젯 트리에서 현재 위젯의 위치 정보를 담고 있습니다.
  @override
  Widget build(BuildContext context) {
    // MaterialApp은 머티리얼 디자인 기반의 앱을 구성하는 최상위 위젯입니다.
    return MaterialApp(
      title: 'Pomodoro Timer',  // 앱의 제목
      theme: ThemeData(primarySwatch: Colors.blue),  // 앱의 기본 테마 색상
      home: const PomodoroTimerScreen(),  // 앱의 시작 화면
    );
  }
}

// 뽀모도로 타이머의 메인 화면을 구성하는 위젯입니다.
// StatefulWidget은 상태가 변할 수 있는 동적인 위젯입니다.
class PomodoroTimerScreen extends StatefulWidget {
  const PomodoroTimerScreen({super.key});

  // createState()는 StatefulWidget과 연결된 State 객체를 생성합니다.
  // State 객체는 위젯의 상태를 관리하고 UI를 다시 그리는 역할을 합니다.
  @override
  State<PomodoroTimerScreen> createState() => _PomodoroTimerScreenState();
}

// PomodoroTimerScreen의 상태를 관리하는 클래스입니다.
// 언더스코어(_)로 시작하여 private 클래스로 선언됩니다.
class _PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  // Timer 객체를 저장하는 변수입니다.
  // ?는 null 허용을 의미합니다.
  Timer? _timer;

  // 각 작업 구간의 시간을 초 단위로 저장하는 상수들입니다.
  final int _workTime = 25 * 60;      // 25분 작업 시간
  final int _breakTime = 5 * 60;      // 5분 휴식 시간
  final int _longBreakTime = 15 * 60; // 15분 긴 휴식 시간

  // 현재 남은 시간을 초 단위로 저장하는 변수입니다.
  int _remainingTime = 25 * 60;

  // 현재 상태가 작업 시간인지 휴식 시간인지 구분하는 플래그입니다.
  bool _isWorkTime = true;

  // 완료된 작업 세션 수를 저장하는 변수입니다.
  // 0부터 3까지 순환하며, 4회차마다 긴 휴식이 주어집니다.
  int _completedSessions = 0;

  // initState는 위젯이 생성될 때 한 번만 호출되는 메서드입니다.
  // 초기화 작업을 수행합니다.
  @override
  void initState() {
    super.initState();
    startTimer();  // 타이머 시작
  }

  // 타이머를 시작하는 메서드입니다.
  void startTimer() {
    print('flutter: Pomodoro 타이머를 시작합니다.');

    // Timer.periodic은 지정된 주기마다 콜백 함수를 실행합니다.
    // Duration은 시간 간격을 지정하는 클래스입니다.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // setState는 상태 변경을 알리고 UI를 다시 그리도록 합니다.
      setState(() {
        if (_remainingTime > 0) {
          print('flutter: ${_formatTime(_remainingTime)}');
          _remainingTime--;
        } else {
          if (_isWorkTime) {
            // 작업 시간이 끝났을 때의 처리
            _completedSessions = (_completedSessions + 1) % 4;
            // 삼항 연산자로 4회차일 때 긴 휴식, 아닐 때 일반 휴식 설정
            _remainingTime = _completedSessions == 0 ? _longBreakTime : _breakTime;
            print('flutter: 작업 시간이 종료되었습니다. 휴식 시간을 시작합니다.');
          } else {
            // 휴식 시간이 끝났을 때의 처리
            _remainingTime = _workTime;
            print('flutter: 휴식 시간이 종료되었습니다. 작업 시간을 시작합니다.');
          }
          _isWorkTime = !_isWorkTime;  // 작업/휴식 상태 전환
        }
      });
    });
  }

  // 현재 구간의 마지막 1초로 건너뛰는 메서드입니다.
  void _skipToEnd() {
    setState(() {
      _remainingTime = 1;
    });
  }

  // 초 단위 시간을 'MM:SS' 형식의 문자열로 변환하는 메서드입니다.
  String _formatTime(int seconds) {
    // ~/는 몫을 구하는 연산자입니다.
    int minutes = seconds ~/ 60;
    // %는 나머지를 구하는 연산자입니다.
    int remainingSeconds = seconds % 60;
    // padLeft는 문자열의 왼쪽을 지정된 문자로 채웁니다.
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // 현재 세션의 상태를 문자열로 반환하는 메서드입니다.
  String _getSessionStatus() {
    if (_isWorkTime) return '작업 시간';
    // 삼항 연산자로 긴 휴식과 일반 휴식을 구분합니다.
    return _completedSessions == 0 ? '긴 휴식 시간 (15분)' : '휴식 시간 (5분)';
  }

  // dispose는 위젯이 제거될 때 호출되는 메서드입니다.
  // 사용한 리소스를 정리합니다.
  @override
  void dispose() {
    _timer?.cancel();  // 타이머 정지
    super.dispose();
  }

  // build 메서드는 위젯의 UI를 구성합니다.
  @override
  Widget build(BuildContext context) {
    // Scaffold는 기본적인 앱 화면 구조를 제공하는 위젯입니다.
    return Scaffold(
      // AppBar는 앱의 상단 바를 구성합니다.
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
      ),
      // GestureDetector는 사용자의 제스처를 감지하는 위젯입니다.
      body: GestureDetector(
        onDoubleTap: _skipToEnd,  // 더블 탭 감지
        child: Center(
          // Column은 자식 위젯들을 세로로 배열하는 위젯입니다.
          child: Column(
            // mainAxisAlignment는 세로 방향 정렬을 지정합니다.
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 타이머 시간을 표시하는 Text 위젯
              Text(
                _formatTime(_remainingTime),
                style: const TextStyle(fontSize: 48),
              ),
              // SizedBox는 고정된 크기의 공간을 만듭니다.
              const SizedBox(height: 20),
              // 현재 상태를 표시하는 Text 위젯
              Text(
                _getSessionStatus(),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
              // 사용자 안내 메시지를 표시하는 Text 위젯
              const Text(
                '시간을 더블클릭하면 현재 구간의 마지막 1초로 이동합니다',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
오류 1 : 작업도중 android studio 에서 "No Connected Devices Found"  오류 발생.
	연결된 디바이스가 없는 경우 발생하는 오류임
	실제 안드로이드 기기가 연결되어 있지 않음
	안드로이드 에뮬레이터가 실행되어 있지 않음
  
  해결 : 에뮬레이터를 실행해서 해결


오류 2 : Warning: SDK processing. 
	This version only understands SDK XML versions up to 3 but an SDK XML file of version 4 was encountered.
	This can happen if you use versions of Android Studio and the command-line tools that were released at different times.

  원인
  Android Studio와 SDK 도구의 버전이 서로 다른 시기에 릴리스되어 발생하는 문제
  해결
  Android Studio의 SDK Manager를 통해 command-line tools를 최신 버전으로 업데이트합니다.
  Tools -> SDK Manager -> SDK Tools 탭에서 "Android SDK Command-line Tools"를 최신 버전으로 업데이트

*/

/*
회고
 Pomodoro 타이머 구현을 통해 몇 가지 중요한 점을 배웠습니다:
 	1.	모듈화의 중요성: 각 기능(작업 세션, 짧은 휴식, 긴 휴식)을 별도의 메서드로 분리함으로써 코드의 가독성과 유지보수성을 높였습니다. 이는 향후 기능 확장이나 수정 시 유용할 것입니다.
 	2.	Timer.periodic의 활용: Dart의 `Timer.periodic`을 사용하여 주기적인 작업을 효과적으로 구현할 수 있었습니다. 이는 실시간으로 변화하는 값을 다룰 때 매우 유용한 도구입니다.
 	3.	상태 관리: `currentCycle` 변수를 통해 현재 진행 상황을 추적하는 방법을 학습했습니다. 이는 복잡한 로직을 단순화하는 데 도움이 되었습니다.
 	4.	콜백 함수의 사용: `_startCountdown` 메서드에서 콜백 함수를 사용하여 카운트다운 완료 후의 동작을 유연하게 처리할 수 있었습니다. 이는 비동기 프로그래밍의 중요한 개념입니다.
 	5.	사용자 경험 고려: 남은 시간을 실시간으로 출력함으로써 사용자에게 현재 상태를 명확히 전달할 수 있었습니다. 이는 실제 애플리케이션에서 중요한 UX 요소입니다.
 	6.	확장성: 현재는 콘솔 기반이지만, 이 구조를 바탕으로 GUI나 모바일 앱으로 쉽게 확장할 수 있습니다. Flutter와 같은 프레임워크를 사용하여 시각적 요소를 추가할 수 있을 것입니다.
 	7.	테스트의 필요성: 실제 사용을 위해서는 각 기능에 대한 단위 테스트와 통합 테스트가 필요할 것입니다. 이는 코드의 안정성을 보장하는 데 중요합니다.
 	8.	사용자 설정 옵션: 향후 개선 사항으로, 사용자가 작업 시간과 휴식 시간을 직접 설정할 수 있는 기능을 추가하면 더욱 유용한 애플리케이션이 될 것입니다.
 처음으로 코드에서 오류 발생이 없었음.
 이 프로젝트를 통해 Dart 언어의 기본 문법과 비동기 프로그래밍, 그리고 객체 지향 설계의 기본 원칙을 실제로 적용해볼 수 있었습니다. 이는 더 복잡한 애플리케이션을 개발하는 데 있어 좋은 기초 쌓았다고 생각됩니다.
*/
// 아주 보람 찬 하루였습니다.



