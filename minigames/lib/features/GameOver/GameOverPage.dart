import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minigames/features/GameOver/widgets/buttons.dart';
import 'package:minigames/features/GameOver/widgets/score.dart';
import '../../core/ScoreManager.dart';
import '../BugGame/BugGamePage.dart';
import '../Home/HomePage.dart';
import '../Home/widgets/scoreboard.dart';
import '../Home/widgets/background_image.dart';
import '../../core/colors.dart';
import '../RunGame/RunGamePage.dart';
import '../CoupleGame/CoupleGamePage.dart';

final ScoreManager scoreManager = ScoreManager();


class GameOverPage extends StatelessWidget {

  final ScoreManager scoreManager;
  const GameOverPage({super.key, required this.scoreManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Score(scores: [720, 700, 600], scoreManager: scoreManager),
                  const SizedBox(height: 30),
                  // ✅ HOME & RETRY 버튼을 가로로 나란히 배치
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      // ✅ 모듈화한 Buttons 사용
                      Buttons(scoreManager: scoreManager),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 30,
            right: 70,
            child: SvgPicture.asset(
              'assets/vectors/user.svg',
              width: 40,
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: SvgPicture.asset(
              'assets/vectors/setting.svg',
              width: 40,
            ),
          ),
        ],
      ),
    );
  }
}
