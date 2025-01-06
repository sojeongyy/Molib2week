import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import '../CoupleGame/CorrectPage.dart';
import '../RoundPage.dart';
import '../RunGame/NotCollisionPage.dart';
import 'widgets/scoreboard.dart';
import '../Login/widgets/background_image.dart';
import '../../core/colors.dart';
import '../RunGame/RunGamePage.dart';
import '../CoupleGame/CoupleGamePage.dart';

// ✅ 게임을 성공 후 RoundPage를 거쳐 랜덤 게임 시작 (mounted 체크 추가)
void startRandomGame(BuildContext context, int roundNumber) {
  final random = Random().nextBool();

  // ✅ mounted 체크를 위한 'context.mounted'
  if (!context.mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => random
          ? CoupleGamePage(
        onGameSuccess: () {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RoundPage(
                  roundNumber: roundNumber + 1,
                  onRoundComplete: () {
                    startRandomGame(context, roundNumber + 1);
                  },
                ),
              ),
            );
          }
        },
      )
          : RunGamePage(
        onGameSuccess: () {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RoundPage(
                  roundNumber: roundNumber + 1,
                  onRoundComplete: () {
                    startRandomGame(context, roundNumber + 1);
                  },
                ),
              ),
            );
          }
        },
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
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
                  Scoreboard(scores: [720, 700, 600]),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (context.mounted) {
                        startRandomGame(context, 1); // ✅ 첫 번째 라운드 시작 (mounted 체크)
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.softBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      'PLAY',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
