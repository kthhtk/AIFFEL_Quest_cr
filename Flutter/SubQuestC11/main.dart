// Flutter의 Material Design 위젯을 사용하기 위한 패키지
import 'package:flutter/material.dart';
// Timer 클래스를 사용하기 위한 비동기 패키지
import 'dart:async';

// 앱의 시작점. runApp을 호출하여 앱을 실행합니다.
void main() {
  runApp(const MyApp());
}

// 앱의 루트 위젯. MaterialApp을 반환하여 앱의 기본 테마와 홈 화면을 설정합니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PomodoroTimerScreen(),
    );
  }
}

// Pomodoro 타이머 화면을 구현하는 StatefulWidget
class PomodoroTimerScreen extends StatefulWidget {
  const PomodoroTimerScreen({super.key});

  @override
  State<PomodoroTimerScreen> createState() => _PomodoroTimerScreenState();
}

// PomodoroTimerScreen의 상태를 관리하는 State 클래스
class _PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  // 타이머 객체를 저장할 변수
  Timer? _timer;

  // 각 구간의 시간을 초 단위로 저장하는 상수
  final int _workTime = 25 * 60;      // 25분 작업
  final int _breakTime = 5 * 60;      // 5분 휴식
  final int _longBreakTime = 15 * 60; // 15분 긴 휴식

  // 현재 남은 시간을 초 단위로 저장
  int _remainingTime = 25 * 60;

  // 현재가 작업 시간인지 휴식 시간인지 구분하는 플래그
  bool _isWorkTime = true;

  // 완료된 작업 세션 수 (0-3: 4회마다 긴 휴식)
  int _completedSessions = 0;

  @override
  void initState() {
    super.initState();
    // 화면이 처음 생성될 때 타이머 시작
    startTimer();
  }

  // 타이머 시작 메서드
  void startTimer() {
    print('flutter: Pomodoro 타이머를 시작합니다.');

    // 1초마다 콜백 함수를 실행하는 타이머 생성
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          // 남은 시간이 있으면 시간을 출력하고 1초 감소
          print('flutter: ${_formatTime(_remainingTime)}');
          _remainingTime--;
        } else {
          if (_isWorkTime) {
            // 작업 세션이 끝났을 때
            _completedSessions = (_completedSessions + 1) % 4;
            // 4번째 작업 세션 후에는 긴 휴식, 그 외에는 짧은 휴식
            _remainingTime = _completedSessions == 0 ? _longBreakTime : _breakTime;
            print('flutter: 작업 시간이 종료되었습니다. 휴식 시간을 시작합니다.');
          } else {
            // 휴식 시간이 끝났을 때
            _remainingTime = _workTime;
            print('flutter: 휴식 시간이 종료되었습니다. 작업 시간을 시작합니다.');
          }
          _isWorkTime = !_isWorkTime;
        }
      });
    });
  }

  // 현재 구간의 마지막 1초로 건너뛰는 메서드
  void _skipToEnd() {
    setState(() {
      _remainingTime = 1;  // 현재 구간의 마지막 1초로 설정
    });
  }

  // 초 단위 시간을 'MM:SS' 형식의 문자열로 변환하는 메서드
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;  // 분 계산 (몫)
    int remainingSeconds = seconds % 60;  // 초 계산 (나머지)
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // 현재 세션 상태를 문자열로 반환하는 메서드
  String _getSessionStatus() {
    if (_isWorkTime) return '작업 시간';
    return _completedSessions == 0 ? '긴 휴식 시간 (15분)' : '휴식 시간 (5분)';
  }

  @override
  void dispose() {
    // 화면이 종료될 때 타이머 정리
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
      ),
      body: GestureDetector(
        onDoubleTap: _skipToEnd,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(_remainingTime),
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 20),
              Text(
                _getSessionStatus(),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
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
