import 'package:flutter/material.dart';
import 'package:minigames/core/BackgroundMusicManager.dart';
import 'package:minigames/features/GameOver/widgets/buttons.dart';
import 'package:minigames/features/GameOver/widgets/score.dart';
import '../../core/ScoreManager.dart';
import '../Home/widgets/background_image.dart';

final ScoreManager scoreManager = ScoreManager();

class GameOverPage extends StatefulWidget {
  final ScoreManager scoreManager;
  const GameOverPage({super.key, required this.scoreManager});

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // ✅ 비행기 애니메이션 컨트롤러 설정
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // 5초간 비행
      vsync: this,
    )..repeat(); // 반복 애니메이션

    _animation = Tween<double>(
      begin: 1.0, // 오른쪽 바깥 시작
      end: -1.0,  // 왼쪽 바깥 끝
    ).animate(_controller);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BackgroundMusicPage.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ 메모리 누수 방지
    super.dispose();
  }

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
                      Buttons(scoreManager: scoreManager),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ✅ 비행기 애니메이션 추가
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: 70, // ✅ 스코어보드 바로 위쪽
                left: MediaQuery.of(context).size.width * _animation.value, // 오른쪽에서 왼쪽으로 이동
                child: Image.asset(
                  'assets/images/plane.png',
                  width: 300,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
