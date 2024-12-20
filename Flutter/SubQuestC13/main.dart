import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

// 메인 앱 위젯
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

// 첫 번째 페이지
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool isCat = true; // isCat의 기본값은 true

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FaIcon(
          FontAwesomeIcons.cat,
          size: 40,
          color: Colors.grey,
        ), // 고양이 아이콘 추가
        title: Text('First Page'), // AppBar에 "First Page" 텍스트 추가
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // "Next" 버튼 클릭 시 SecondPage로 이동하며 isCat을 false로 설정
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondPage(isCat: false),
                  ),
                );

                // SecondPage에서 반환된 값을 업데이트
              },
              child: Text('Next'), // 버튼 텍스트 "Next"
            ),
            SizedBox(height: 20), // 여백 추가
            GestureDetector(
              onTap: () {
                print('isCat 상태: $isCat'); // 현재 상태를 콘솔에 출력
              },
              child: Image.asset(
                'assets/cat.png', // 고양이 이미지 (300x300)
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 두 번째 페이지
class SecondPage extends StatelessWidget {
  final bool isCat;

  SecondPage({required this.isCat}); // isCat 값을 생성자에서 전달받음

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FaIcon(FontAwesomeIcons.dog,
            size: 40, color: Colors.brown[300]), // 강아지 아이콘 추가
        title: Text('Second Page'), // AppBar에 "Second Page" 텍스트 추가
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // "Back" 버튼 클릭 시 이전 페이지로 돌아가며 isCat을 true로 설정해 반환
                Navigator.pop(context, true);
              },
              child: Text('Back'), // 버튼 텍스트 "Back"
            ),
            SizedBox(height: 20), // 여백 추가
            GestureDetector(
              onTap: () {
                print('isCat 상태: $isCat'); // 현재 상태를 콘솔에 출력
              },
              child: Image.asset(
                'assets/dog.png', // 강아지 이미지 (300x300)
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




/*

회고: 전반적으로 작성한 내용에 대해서는 이해할 수 있었다. 아이콘 사이즈와 컬러 변경, 이미지 사이즈 300으로 변경 등 디자인 측면도 적용해 보면서
즐겁게 작업할 수 있었다. 배운 내용을 적용하는 즐거움이 크다. 

아이콘을 변경을 위해 새로운 외부 라이브러리를 불러오고, 여러 설정들을 바꾸고, 코드에 대해 같이 이야기를 나누며
조금더 개념적으로 이해하며 성장하는 좋은 시간이였다고 생각합니다.

*/
