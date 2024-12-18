import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());  // 앱의 시작점
}

class MyApp extends StatelessWidget {  // 상태가 변하지 않는 정적 위젯
  @override
  Widget build(BuildContext context) {
    return MaterialApp(  // 머티리얼 디자인을 사용하는 앱
      home: Scaffold(  // 기본적인 앱 구조를 제공
        appBar: AppBar(  // 상단 앱바
          leading: Icon(Icons.alarm),  // 좌측 알람 아이콘
          title: Text('플러터 앱 만들기기'),  // 앱바 제목
          centerTitle: true,  // 제목 중앙 정렬
          backgroundColor: Colors.blue,  // 앱바 배경색
        ),
        body: Center(  // 본문을 중앙 정렬
          child: Column(  // 세로로 위젯 배치
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // 세로 방향 균등 배치
              children: [
                ElevatedButton(  // 버튼 위젯
                  onPressed: () {  // 버튼 클릭 시 실행될 함수
                    print('버튼이 눌렸습니다.');
                  },
                  child: Text('Text'),  // 버튼 텍스트
                ),
                Stack(  // 위젯들을 겹쳐서 배치
                  children: [  // Stack에 포함될 위젯들
                    Container(  // 300x300 빨간색 상자
                      width: 300,
                      height: 300,
                      color: Colors.red,
                    ),
                    Container(  // 240x240 주황색 상자
                      width: 240,
                      height: 240,
                      color: Colors.orange,
                    ),
                    Container(  // 180x180 노란색 상자
                      width: 180,
                      height: 180,
                      color: Colors.yellow,
                    ),
                    Container(  // 120x120 초록색 상자
                      width: 120,
                      height: 120,
                      color: Colors.green,
                    ),
                    Container(  // 60x60 파란색 상자
                      width: 60,
                      height: 60,
                      color: Colors.blue,
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}





/*
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            print('버튼이 눌렸습니다');
          },
          child: Text('Text'),
원래는 버튼 부분까지만 구현하고 나서 밑에 스택 부분을 구현함에 있어서
버튼 밑에 배치되게 하려고했었습니다.
하지만 지금 위의 코드대로라면 센터는 하나의 위젯만 자식으로 포함 할 수 있어서
센터에 컬럼을 자식 속성으로받게하여 즉 여러가지 위젯을 받을수 있게 만들었고
위아래로 버튼부분과 스택부분이 구현되게 수정하였습니다.

속성 child, chilren 의 차이에 따라 오류가 생겼었다. 
위젯의 종류에 따라 하위에 child(하나), children(여러개) 중 하나만 사용할 수 있게 설계되어 있다는걸 확실히 했다.


이국한 : 이번 문제느 간단한거 같으면서도 쉽게 놓칠 수 있는 부분에 대해서 인지하고 갈 수 있었던거 같아 좋았습니다. 
특히 차일드와 칠드런 부분에서 실제로 크게 인지하지 못하고 있었는데 이번에 코드를 직접 작성해야되는 부분이 생김으로써 좀더 제대로 알 수 있었던 거 같았습니다. 
그리고 프레임 워크라고는 하지만 이게 비주얼 적인 인터페이스가 아닌 코드를 사용하기에 얼마나 편한지 얼마나 좋은지가 를 가지고 오늘 좀더 깨닫게 되었습니다.

김태훈:이 문제가 난이도상 다트 첫 코딩 문제였으면 어땠을까 싶다.
같이 이야기하며 한문장 한문장 완성하는 재미가 있었다.

*/
