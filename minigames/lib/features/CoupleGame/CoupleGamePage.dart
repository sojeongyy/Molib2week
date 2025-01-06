import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minigames/features/CoupleGame/InCorrectPage.dart';
import '../../core/ScoreManager.dart';
import '../../core/Timer.dart';
import 'CorrectPage.dart';

class CoupleGamePage extends StatefulWidget {
  final int level; // 난이도
  final ScoreManager scoreManager;

  const CoupleGamePage({super.key, required this.level, required this.scoreManager});

  @override
  State<CoupleGamePage> createState() => _CoupleGamePageState();
}

class _CoupleGamePageState extends State<CoupleGamePage> with SingleTickerProviderStateMixin{
  String speechBubbleImage = 'assets/images/green_think.png';
  late TimerManager timerManager;
  late AnimationController _controller;
  int gameDuration = 5;
  bool isGameOver = true;

  @override
  void initState() {
    super.initState();

    // ✅ 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _setRandomSpeechBubble();

    // ✅ 난이도에 따라 제한 시간 조정
    gameDuration -= widget.level * 1;
    if (gameDuration < 1) gameDuration = 1; // 최소 1초 제한

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
        if (isGameOver && mounted) {
          setState(() {
            isGameOver = false;
            _controller.stop();
          });
          if (mounted) {
            widget.scoreManager.addPoints(100); // ✅ 점수 즉시 추가
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InCorrectPage(scoreManager: widget.scoreManager)),
            );
          }
        }
      },
    );
    timerManager.startTimer();
  }

  // ✅ 말풍선을 랜덤으로 선택하는 함수
  void _setRandomSpeechBubble() {
    final speechBubbles = [
      'assets/images/blue_think.png',
      'assets/images/brown_think.png',
      'assets/images/green_think.png',
      'assets/images/yellow_think.png',
    ];
    speechBubbleImage = speechBubbles[Random().nextInt(speechBubbles.length)];
  }

  // 정답 캐릭터 결정 (말풍선에 따라)
  String getTargetCharacter() {
    if (speechBubbleImage == 'assets/images/green_think.png') {
      return 'assets/images/green_person.png';
    } else if (speechBubbleImage == 'assets/images/yellow_think.png') {
      return 'assets/images/yellow_person.png';
    } else if (speechBubbleImage == 'assets/images/brown_think.png') {
      return 'assets/images/brown_person.png';
    } else {
      return 'assets/images/blue_person.png';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String targetCharacter = getTargetCharacter();

    return Scaffold(
      backgroundColor: const Color(0xFFFFE1FB),
      body: Stack(
        children: [
          // ✅ 상단 타이머 추가
          Positioned(
            top: 20,
            left: 0,
            child: buildProgressBar(timerManager.timeLeft, gameDuration),
          ),
          // ✅ 중앙 캐릭터와 드래그 타겟
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                DragTarget<String>(
                  onAccept: (data) {
                    if (data == targetCharacter) {
                      // ✅ mounted 체크 추가 (안전성 보장)
                      Future.delayed(Duration.zero, () {
                        if (mounted) {  // ✅ 비동기 이후 상태 체크
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CorrectPage(correctCharacter: targetCharacter, level: widget.level),
                            ),
                          );
                        }
                      });
                    }
                    else {
                      // InCorrectPage 로 네비게이션
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InCorrectPage(scoreManager: widget.scoreManager)), // 직접 페이지 지정
                      );
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Image.asset('assets/images/pink_person.png', width: 150);
                  },
                ),
              ],
            ),
          ),

          // ✅ 말풍선 (중앙 캐릭터보다 살짝 위 오른쪽)
          Positioned(
            top: 200,
            right: 40,
            child: Image.asset(
              speechBubbleImage,
              width: 120,
            ),
          ),

          // ✅ 상단 캐릭터 (오답)
          Positioned(
            top: 100,
            left: 50,
            child: Draggable<String>(
              data: 'assets/images/blue_person.png',
              feedback: Image.asset('assets/images/blue_person.png', width: 100),
              child: Image.asset('assets/images/blue_person.png', width: 100),
            ),
          ),

          // ✅ 우측 캐릭터 (오답)
          Positioned(
            top: 100,
            right: 40,
            child: Draggable<String>(
              data: 'assets/images/yellow_person.png',
              feedback: Image.asset('assets/images/yellow_person.png', width: 100),
              child: Image.asset('assets/images/yellow_person.png', width: 100),
            ),
          ),

          // ✅ 하단 캐릭터 (정답일 수도 있음)
          Positioned(
            bottom: 40,
            left: 40,
            child: Draggable<String>(
              data: 'assets/images/green_person.png',
              feedback: Image.asset('assets/images/green_person.png', width: 100),
              child: Image.asset('assets/images/green_person.png', width: 100),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Draggable<String>(
              data: 'assets/images/brown_person.png',
              feedback: Image.asset('assets/images/brown_person.png', width: 100),
              child: Image.asset('assets/images/brown_person.png', width: 100),
            ),
          ),
        ],
      ),
    );
  }
}
