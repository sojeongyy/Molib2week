import 'package:flutter/material.dart';

import '../../core/BackgroundMusicManager.dart';
import '../../core/ScoreButton.dart';
import '../../core/ScoreManager.dart';

class InCorrectPage extends StatelessWidget {
  final ScoreManager scoreManager;
  const InCorrectPage({super.key, required this.scoreManager});

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BackgroundMusicPage.play(assetPath: 'audios/fail.mp3');  // ✅ 배경음악 재개
    });

    return Scaffold(
        backgroundColor: const Color(0xFFF47599), // 배경색
        body: Stack(
          children: [
            // ✅ 중앙 캐릭터 (정답 판단 X)
            Center(
              child: Image.asset('assets/images/pink_person.png', width: 150),
            ),

            // ✅ 말풍선 (중앙 캐릭터보다 위 오른쪽에 위치)
            Positioned(
              top: 200,
              right: 40,
              child: Image.asset(
                'assets/images/incorrect_think.png',
                width: 120,
              ),
            ),

            // ✅ 상단 캐릭터 (드래그 제거)
            Positioned(
              top: 100,
              left: 50,
              child: Image.asset('assets/images/blue_person.png', width: 100),
            ),

            // ✅ 우측 캐릭터 (드래그 제거)
            Positioned(
              top: 100,
              right: 40,
              child: Image.asset('assets/images/yellow_person.png', width: 100),
            ),

            // ✅ 하단 캐릭터 (드래그 제거)
            Positioned(
              bottom: 40,
              left: 40,
              child: Image.asset('assets/images/green_person.png', width: 100),
            ),

            Positioned(
              bottom: 20,
              right: 20,
              child: Image.asset('assets/images/brown_person.png', width: 100),
            ),

            ScoreButton(scoreManager: scoreManager),
          ],
        ),
    );
  }
}
