import 'package:flutter/material.dart';
import 'package:minigames/core/colors.dart';

import '../../core/BackgroundMusicManager.dart';
import '../../core/ScoreButton.dart';
import '../../core/ScoreManager.dart';

class UhWrongPage extends StatelessWidget {

  final ScoreManager scoreManager;
  const UhWrongPage({super.key, required this.scoreManager});

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BackgroundMusicPage.play(assetPath: 'audios/fail.mp3');  // ✅ 배경음악 재개
    });

    return Scaffold(
      backgroundColor: AppColors.customBlue, // 배경색
      body: Stack(
        children: [
          // ✅ 배경 이미지 (중앙 정렬)
          Center(
            child: Image.asset(
              'assets/images/Uh_image.jpg',
              width: 300,                  // 이미지 크기 조정
              fit: BoxFit.contain,         // 이미지 비율 유지
            ),
          ),
          ScoreButton(scoreManager: scoreManager),
        ],
      ),
    );
  }
}

