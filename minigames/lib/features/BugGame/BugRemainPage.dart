import 'package:flutter/material.dart';

class BugRemainPage extends StatelessWidget {
  const BugRemainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAFFFD),
      body: Center(
        child: Stack(
          children: [
            // 컴퓨터 이미지 중앙 정렬
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.1,
              child: Image.asset(
                'assets/images/blueScreen.png',
                width: 400,
              ),
            ),
            // 벌레 이미지 (왼쪽 상단)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3 - 50,
              left: MediaQuery.of(context).size.width * 0.11,
              child: Image.asset(
                'assets/images/bugTalking.png',
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
