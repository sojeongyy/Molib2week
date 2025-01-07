import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/BackgroundMusicManager.dart';
import '../../core/ScoreManager.dart';
import '../../core/Timer.dart';
import 'BugRemainPage.dart';
import 'BugSuccessPage.dart';

class BugGamePage extends StatefulWidget {
  final int level; // 난이도에 따라 벌레의 개수를 조정
  final ScoreManager scoreManager;

  const BugGamePage({super.key, required this.level, required this.scoreManager});

  @override
  State<BugGamePage> createState() => _BugGamePageState();
}

class _BugGamePageState extends State<BugGamePage> with SingleTickerProviderStateMixin {
  List<Offset> bugPositions = [];
  List<bool> bugCaught = [];
  final int bugImageSize = 25;
  final double computerImageWidth = 400;
  final double computerImageHeight = 300;
  late TimerManager timerManager;
  late AnimationController _controller;
  bool _isDisposed = false; // ✅ 추가: 중복 방지 플래그
  int gameDuration = 5;

  @override
  void initState() {
    BackgroundMusicPage.play(assetPath: 'audios/bug_sound.mp3');
    // ✅ 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // ✅ 난이도에 따라 타이머와 벌레 수 조정
    gameDuration -= widget.level;
    if (gameDuration < 2) gameDuration = 2; // 최소 제한 시간 2초
    _generateBugPositions();

    // ✅ TimerManager 초기화
    timerManager = TimerManager(
      context: context,
      duration: gameDuration,
      controller: _controller,
      onUpdate: (timeLeft) {
        if (mounted) {
          setState(() {});
        }
      },
      onComplete: () {
        if (mounted && !_isDisposed) {
          _isDisposed = true; // ✅ 중복 방지
          _controller.stop();

          // ✅ 점수 계산
          int bugsCaught = bugCaught.where((caught) => caught).length;
          int totalBugs = bugCaught.length;
          double scoreRatio = bugsCaught / totalBugs;
          int additionalPoints = (100 * scoreRatio).round(); // ✅ 점수 계산 후 반올림
          widget.scoreManager.addPoints(additionalPoints);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BugRemainPage(scoreManager: widget.scoreManager)),
          );
        }
      },
    );

    timerManager.startTimer(); // ✅ 타이머 시작
  }

  void _generateBugPositions() {
    bugPositions.clear();
    final int bugCount = widget.level + 2; // 난이도에 따라 벌레 수 증가
    final Random random = Random();

    for (int i = 0; i < bugCount; i++) {
      double x = random.nextDouble() * (computerImageWidth - bugImageSize);
      double y = random.nextDouble() * (computerImageHeight - bugImageSize);

      // ✅ 벌레가 화면 밖으로 나가지 않도록 제한
      if (x + bugImageSize > computerImageWidth) {
        x = computerImageWidth - bugImageSize;
      }
      if (y + bugImageSize > computerImageHeight) {
        y = computerImageHeight - bugImageSize;
      }

      bugPositions.add(Offset(x, y));
      bugCaught.add(false); // 벌레를 아직 잡지 않은 상태로 초기화
    }
    setState(() {});
  }

  void _removeBug(int index) {
    setState(() {
      bugCaught[index] = true; // 벌레를 잡았을 때 상태 변경
    });
    if (bugCaught.every((caught) => caught)) {
      if (mounted && !_isDisposed) {
        _isDisposed = true; // ✅ 중복 방지
        widget.scoreManager.addPoints(100); // ✅ 100점 추가
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BugSuccessPage(level: widget.level)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF61E1B4),
      body: Stack( // ✅ Positioned를 사용하기 위해 Stack으로 변경
        children: [
          // ✅ 상단 타이머 프로그레스 바 (Stack의 첫 번째 요소)
          Positioned(
            top: 20,
            left: 0,
            child: buildProgressBar(timerManager.timeLeft, gameDuration),
          ),

          // ✅ 중앙 콘텐츠 (Text + 이미지)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "벌레를 잡아라. Fix the Bug kk!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // 컴퓨터 이미지와 벌레들
                Center(
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/bug_computer.png',
                        width: computerImageWidth,
                        height: computerImageHeight,
                      ),
                      ...List.generate(bugPositions.length, (index) {
                        return Positioned(
                          top: bugPositions[index].dy,
                          left: bugPositions[index].dx,
                          child: GestureDetector(
                            onTap: () => _removeBug(index),
                            child: Image.asset(
                              bugCaught[index]
                                  ? 'assets/images/deadbug.png'
                                  : 'assets/images/bug.png',
                              width: bugImageSize.toDouble(),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true; // ✅ 중복 방지
      timerManager.dispose();
      _controller.dispose();
      BackgroundMusicPage.stop();
    }
    super.dispose();
  }
}

