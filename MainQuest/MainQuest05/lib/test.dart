import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  final Function(String weather, int temperature) onApply; // 값 적용 콜백 함수

  TestPage({required this.onApply});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String selectedWeather = '맑음'; // 기본 날씨 값
  int selectedTemperature = 20; // 기본 온도 값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테스트 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날씨 선택 버튼
            Text('날씨 설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['맑음', '흐림', '비', '눈'].map((weather) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedWeather = weather;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedWeather == weather ? Colors.blue : Colors.grey,
                  ),
                  child: Text(weather),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // 온도 설정 슬라이더
            Text('온도 설정 (${selectedTemperature}°C)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Slider(
              value: selectedTemperature.toDouble(),
              min: -10,
              max: 40,
              divisions: 50,
              label: '$selectedTemperature°C',
              onChanged: (value) {
                setState(() {
                  selectedTemperature = value.toInt();
                });
              },
            ),
            SizedBox(height: 20),

            // 적용 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                      selectedWeather, selectedTemperature); // 선택된 값을 콜백으로 전달
                  Navigator.pop(context); // 테스트 페이지 닫기
                },
                child: Text('적용'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
