import 'package:flutter/material.dart';
import 'gemini_service.dart'; // Gemini API 호출용 서비스

class GeminiTextBox extends StatefulWidget {
  final int temperature; // 온도값 (외부에서 전달받음)

  GeminiTextBox({required this.temperature});

  @override
  _GeminiTextBoxState createState() => _GeminiTextBoxState();
}

class _GeminiTextBoxState extends State<GeminiTextBox> {
  String _response = '데이터를 불러오는 중입니다...'; // 초기 텍스트

  @override
  void initState() {
    super.initState();
    _fetchGeminiResponse(); // 초기 데이터 로드
  }

  @override
  void didUpdateWidget(covariant GeminiTextBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 온도값이 변경되었을 때만 재요청
    if (oldWidget.temperature != widget.temperature) {
      _fetchGeminiResponse();
    }
  }

  // Gemini API 호출 메서드
  Future<void> _fetchGeminiResponse() async {
    setState(() {
      _response = '데이터를 불러오는 중입니다...'; // 로딩 상태 표시
    });

    try {
      final prompt = '${widget.temperature}도 옷차림 간략히'; // 요청 메시지 생성
      final response = await GeminiService.askGemini(prompt); // API 호출
      setState(() {
        _response = response; // 응답 결과 저장
      });
    } catch (e) {
      setState(() {
        _response = '오류가 발생했습니다. 다시 시도해주세요.'; // 오류 메시지 표시
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      width: screenWidth * 0.96,
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.3,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Text(
          _response,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
