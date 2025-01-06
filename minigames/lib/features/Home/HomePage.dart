import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minigames/features/Home/widgets/play_button.dart';
import '../../core/ScoreManager.dart';
import '../BugGame/BugGamePage.dart';
import 'widgets/scoreboard.dart';
import 'widgets/background_image.dart';
import '../../core/colors.dart';
import '../RunGame/RunGamePage.dart';
import '../CoupleGame/CoupleGamePage.dart';

final ScoreManager scoreManager = ScoreManager();


// ✅ 게임을 성공 후 RoundPage를 거쳐 랜덤 게임 시작 (mounted 체크 추가)
void startRandomGame(BuildContext context, int roundNumber, int level) {
  final randomIndex = Random().nextInt(3); // ✅ 3개의 게임을 랜덤으로 선택 (0, 1, 2)

  // ✅ 기존 페이지를 닫고 랜덤으로 새로운 게임 시작
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        switch (randomIndex) {
          case 0:
            return CoupleGamePage(level: level, scoreManager: scoreManager);
          case 1:
            return RunGamePage(level: level, scoreManager: scoreManager);
          case 2:
            return BugGamePage(level: level, scoreManager: scoreManager);
          default:
            return BugGamePage(level: level, scoreManager: scoreManager);
        }
      },
    ),
  );
}
class HomePage extends StatelessWidget {
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
                  Scoreboard(scores: [720, 700, 600]),
                  const SizedBox(height: 50),
                  PlayButton(
                    onPressed: () {
                      startRandomGame(context, 1, 1);
                    },
                    scoreManager: scoreManager, // ✅ 점수 매니저 전달
                  ),
                ],
              ),
            ),
          ),
          // Positioned(
          //   bottom: 10,
          //   left: 30,
          //   child: Image.asset(
          //     'assets/images/brown_person.png',
          //     width: 150,
          //   ),
          // ),
          // Positioned(
          //   bottom: 20,
          //   right: 30,
          //   child: Image.asset(
          //     'assets/images/yellow_person.png',
          //     width: 150,
          //   ),
          // ),
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
