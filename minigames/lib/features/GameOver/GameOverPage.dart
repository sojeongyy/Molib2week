import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minigames/features/GameOver/widgets/score.dart';
import '../../core/ScoreManager.dart';
import '../BugGame/BugGamePage.dart';
import '../Home/HomePage.dart';
import '../Home/widgets/scoreboard.dart';
import '../Login/widgets/background_image.dart';
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
          const BackgroundImage(),
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
                      // HOME 버튼
                      ElevatedButton(
                        onPressed: () {
                          print("Home Button Pressed");
                          scoreManager.resetScore();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.softBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text(
                          'HOME',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20), // ✅ 버튼 간 간격 추가

                      // RETRY 버튼
                      ElevatedButton(
                        onPressed: () {
                          print("Retry Button Pressed");
                          scoreManager.resetScore();
                          startRandomGame(context, 1, 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.softBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text(
                          'RETRY',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 30,
            child: Image.asset(
              'assets/images/brown_person.png',
              width: 150,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 30,
            child: Image.asset(
              'assets/images/yellow_person.png',
              width: 150,
            ),
          ),
          Positioned(
            top: 20,
            right: 70,
            child: SvgPicture.asset(
              'assets/vectors/user.svg',
              width: 40,
            ),
          ),
          Positioned(
            top: 20,
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
