import 'package:flutter/material.dart';

import '../../core/NextButton.dart';

class BugSuccessPage extends StatelessWidget {
  final int level; // ✅ level 추가
  const BugSuccessPage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAFFFD),
      body: Center(
        child: Stack(
          children: [
            // 컴퓨터 이미지 중앙 정렬
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: MediaQuery.of(context).size.width * 0.1,
              child: Image.asset(
                'assets/images/computer.png',
                width: 400,
              ),
            ),
            // 벌레 이미지 (왼쪽 상단)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.3 - 100,
              right: MediaQuery.of(context).size.width * 0.15,
              child: Image.asset(
                'assets/images/bugFuck.png',
                width: 300,
              ),
            ),
            // 로그인 버튼 가운데 정렬
            Center(
              child: NextButton(level: level),
            ),
          ],
        ),
      ),
    );
  }
}
