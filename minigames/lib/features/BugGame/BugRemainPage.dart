import 'package:flutter/material.dart';

import '../../core/BackgroundMusicManager.dart';
import '../../core/ScoreButton.dart';
import '../../core/ScoreManager.dart';

class BugRemainPage extends StatelessWidget {
  final ScoreManager scoreManager;

  const BugRemainPage({super.key, required this.scoreManager});

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BackgroundMusicPage.play(assetPath: 'audios/fail.mp3');  // ✅ 배경음악 재개
    });

    return Scaffold(
      backgroundColor: const Color(0xFF61E1B4),
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
            ScoreButton(scoreManager: scoreManager),
          ],
        ),
      ),
    );
  }
}
