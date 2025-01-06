import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'UhWrongPage.dart';
import 'UhClearPage.dart';

class BalloonGamePage extends StatefulWidget {
  final int level; // 난이도: 말풍선의 개수와 표시 시간 조정
  const BalloonGamePage({super.key, required this.level});

  @override
  State<BalloonGamePage> createState() => _BalloonGamePageState();
}

class _BalloonGamePageState extends State<BalloonGamePage> {
  final List<Map<String, dynamic>> balloons = [];
  final Random random = Random();
  final double characterAreaWidth = 400;
  final double characterAreaHeight = 600;
  int balloonsCaught = 0;
  int balloonsMissed = 0;
  late Timer gameTimer;
  late Timer balloonTimer;
  int gameDuration = 7; // 총 게임 시간
  int maxBalloons = 5;
  double balloonDisplayTime = 1.0;

  @override
  void initState() {
    super.initState();

    // 난이도에 따른 말풍선 설정
    maxBalloons = widget.level + 5; // 말풍선의 개수
    balloonDisplayTime = max(0.3, 1.0 - widget.level * 0.05); // 말풍선 표시 시간

    // 게임 시작
    startGame();
  }

  void startGame() {
    // 게임 타이머 시작
    gameTimer = Timer(Duration(seconds: gameDuration), () {
      if (balloonsMissed > 0) {
        // 게임 오버
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UhWrongPage()),
        );
      } else {
        // 게임 승리
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UhClearPage(level: widget.level)),
        );
      }
    });

    // 말풍선 생성 타이머
    balloonTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (balloons.length < maxBalloons) {
        createBalloon();
      }
    });
  }

  void createBalloon() {
    // 말풍선 종류 리스트
    final List<Map<String, dynamic>> balloonTypes = [
      {"text": "어?", "isCorrect": true},
      {"text": "오~", "isCorrect": false},
      {"text": "아~", "isCorrect": false},
      {"text": "와!", "isCorrect": false},
    ];

    // "헉!" 말풍선 추가 (레벨 10 이상에서만 등장)
    if (widget.level >= 10 && random.nextDouble() < 0.2) {
      final double x = random.nextDouble() * (characterAreaWidth - 60);
      final double y = random.nextDouble() * (characterAreaHeight - 60);

      final specialBalloon = {
        "id": DateTime.now().millisecondsSinceEpoch, // 고유 ID
        "x": x,
        "y": y,
        "text": "헉!", // 특수 말풍선
        "isCorrect": true, // "헉!"도 정답으로 처리
        "isSpecial": true, // 특수 말풍선 여부
      };

      setState(() {
        balloons.add(specialBalloon);
      });

      // 0.2초 후 자동 제거
      Timer(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            balloons.removeWhere((b) => b["id"] == specialBalloon["id"]);
            if (specialBalloon["isCorrect"] == true) {
              balloonsMissed++; // "헉!"을 놓쳤을 경우
              checkGameOver();
            }
          });
        }
      });
      return; // 특수 말풍선만 생성하고 종료
    }

    // 일반 말풍선 생성
    final double x = random.nextDouble() * (characterAreaWidth - 60);
    final double y = random.nextDouble() * (characterAreaHeight - 60);

    // 확률에 따라 말풍선 텍스트 결정
    final double probability = random.nextDouble();
    Map<String, dynamic> selectedBalloon;
    if (probability < 0.5) {
      // 50% 확률로 "어?"
      selectedBalloon = {"text": "어?", "isCorrect": true};
    } else {
      // 나머지 50% 확률에서 균등 분배
      final List<Map<String, dynamic>> otherBalloons = [
        {"text": "오~", "isCorrect": false},
        {"text": "아~", "isCorrect": false},
        {"text": "와!", "isCorrect": false},
      ];
      selectedBalloon = otherBalloons[(probability - 0.5) ~/ (0.5 / otherBalloons.length)];
    }

    final balloon = {
      "id": DateTime.now().millisecondsSinceEpoch, // 고유 ID
      "x": x,
      "y": y,
      "text": selectedBalloon["text"], // 랜덤 텍스트
      "isCorrect": selectedBalloon["isCorrect"], // 정답 여부
    };

    setState(() {
      balloons.add(balloon);
    });

    // 일정 시간 후 말풍선 제거
    Timer(Duration(seconds: balloonDisplayTime.toInt()), () {
      if (mounted) {
        setState(() {
          balloons.removeWhere((b) => b["id"] == balloon["id"]);
          if (balloon["isCorrect"]) {
            balloonsMissed++; // "어?"를 놓쳤을 경우
            checkGameOver();
          }
        });
      }
    });
  }

  void onBalloonTap(int id, bool isCorrect) {
    setState(() {
      balloons.removeWhere((b) => b["id"] == id);
      if (isCorrect) {
        balloonsCaught++;
      } else {
        // 잘못된 말풍선을 터치한 경우
        balloonsMissed++;
        checkGameOver();
      }
    });
  }

  void checkGameOver() {
    if (balloonsMissed > 0) {
      gameTimer.cancel();
      balloonTimer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UhWrongPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Stack(
        children: [
          // 게임 남은 시간 표시
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              "남은 시간: ${gameDuration - gameTimer.tick}s",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),

          // 말풍선 표시
          Center(
            child: SizedBox(
              width: characterAreaWidth,
              height: characterAreaHeight,
              child: Stack(
                children: balloons.map((balloon) {
                  return Positioned(
                    top: balloon["y"],
                    left: balloon["x"],
                    child: GestureDetector(
                      onTap: () => onBalloonTap(balloon["id"], balloon["isCorrect"]),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: balloon["isCorrect"] ? Colors.orange : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          balloon["text"],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer.cancel();
    balloonTimer.cancel();
    super.dispose();
  }
}
