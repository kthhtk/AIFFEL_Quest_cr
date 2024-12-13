// Flutter의 기본 Material Design 위젯을 사용하기 위한 패키지
import 'package:flutter/material.dart';
// Timer 클래스를 사용하기 위한 비동기 패키지
import 'dart:async';

// 앱의 시작점. main 함수에서 runApp을 호출하여 앱을 실행합니다.
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PomodoroTimerScreen(),
    );
  }
}

// Pomodoro 타이머 화면을 구현하는 StatefulWidget
// 상태가 변경되면 화면이 다시 그려집니다.
class PomodoroTimerScreen extends StatefulWidget {
  const PomodoroTimerScreen({super.key});

  @override
  State<PomodoroTimerScreen> createState() => _PomodoroTimerScreenState();
}

// PomodoroTimerScreen의 상태를 관리하는 State 클래스
class _PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  // 타이머 객체를 저장할 변수
  Timer? _timer;

  // 작업 시간 (25분)을 초 단위로 저장
  final int _workTime = 25 * 60;

  // 휴식 시간 (5분)을 초 단위로 저장
  final int _breakTime = 5 * 60;

  // 현재 남은 시간을 초 단위로 저장
  int _remainingTime = 25 * 60;

  // 현재가 작업 시간인지 휴식 시간인지 구분하는 플래그
  bool _isWorkTime = true;

  // 작업 사이클 카운트 (4회마다 긴 휴식)
  int _cycles = 0;

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
          // 시간이 종료되면 작업/휴식 전환
          if (_isWorkTime) {
            _cycles++;
            if (_cycles >= 4) {
              // 4회차 완료 시 긴 휴식(15분)으로 전환
              _remainingTime = 15 * 60;
              _cycles = 0;
            } else {
              // 일반 휴식(5분)으로 전환
              _remainingTime = _breakTime;
            }
            print('flutter: 작업 시간이 종료되었습니다. 휴식 시간을 시작합니다.');
          } else {
            // 휴식 시간이 끝난 경우 작업 시간으로 전환
            _remainingTime = _workTime;
            print('flutter: 휴식 시간이 종료되었습니다. 작업 시간을 시작합니다.');
          }
          _isWorkTime = !_isWorkTime;
        }
      });
    });
  }

  // 초 단위 시간을 'MM:SS' 형식의 문자열로 변환하는 메서드
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
      body: Center(
        child: Text(
          _formatTime(_remainingTime),
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }
}
