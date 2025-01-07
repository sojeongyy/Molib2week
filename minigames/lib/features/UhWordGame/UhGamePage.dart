import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'UhWrongPage.dart';
import 'UhClearPage.dart';

class UhGamePage extends StatefulWidget {
  final int level; // 난이도: 말풍선의 개수와 표시 시간 조정
  const UhGamePage({super.key, required this.level});

  @override
  State<UhGamePage> createState() => _UhGamePageState();
}

class _UhGamePageState extends State<UhGamePage> {
  final List<Map<String, dynamic>> balloons = [];
  final Random random = Random();
  int balloonsCaught = 0;
  int balloonsMissed = 0;
  late Timer gameTimer;
  late Timer balloonTimer;
  int gameDuration = 7; // 총 게임 시간
  late int maxBalloons;
  double balloonDisplayTime = 1.0;

  // 캐릭터 위치 정의
  final List<Offset> characterPositions = [
    Offset(20, 120),
    Offset(190, 120),
    Offset(20, 290),
    Offset(190, 290),
    Offset(20, 460),
    Offset(190, 460),
  ];

  // 각 캐릭터에 말풍선이 있는지 추적
  final List<bool> characterHasBalloon = [false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();

    // 난이도에 따른 말풍선 설정
    maxBalloons = 2 + (widget.level ~/ 5); // 레벨 5마다 1씩 증가, 최대 6
    balloonDisplayTime = max(1.0, 2.5 - widget.level * 0.1); // 말풍선 표시 시간

    // 게임 시작
    startGame();
  }

  void startGame() {
    // 게임 타이머 시작
    gameTimer = Timer(Duration(seconds: gameDuration), () {
      // 7초 동안 게임 오버가 발생하지 않으면 클리어
      balloonTimer.cancel(); // 더 이상 말풍선 생성하지 않음
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UhClearPage(level: widget.level)),
      );
    });

    // 말풍선 생성 타이머
    balloonTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (balloons.length < maxBalloons) {
        createBalloon();
      }
    });
  }

  void createBalloon() {
    List<int> availableCharacters = [];
    for (int i = 0; i < characterHasBalloon.length; i++) {
      if (!characterHasBalloon[i]) {
        availableCharacters.add(i);
      }
    }

    if (availableCharacters.isEmpty) {
      return;
    }

    int characterIndex = availableCharacters[random.nextInt(availableCharacters.length)];
    characterHasBalloon[characterIndex] = true;

    // "헉!" 확률 계산
    double specialBalloonProbability = 0.0;
    if (widget.level >= 10) {
      specialBalloonProbability = (5 + (widget.level - 10)).clamp(5, 30).toDouble() / 100.0;
    }

    final double probability = random.nextDouble();
    Map<String, dynamic> selectedBalloon;

    if (widget.level >= 10 && probability < specialBalloonProbability) {
      selectedBalloon = {
        "image": "assets/images/Huk.png",
        "isCorrect": true,
        "duration": 0.7,
      };
    } else if (probability < 0.5 + specialBalloonProbability) {
      selectedBalloon = {
        "image": "assets/images/Uh.png",
        "isCorrect": true,
        "duration": balloonDisplayTime,
      };
    } else {
      final List<Map<String, dynamic>> otherBalloons = [
        {"image": "assets/images/Oh.png", "isCorrect": false, "duration": balloonDisplayTime},
        {"image": "assets/images/Ah.png", "isCorrect": false, "duration": balloonDisplayTime},
        {"image": "assets/images/Wa!.png", "isCorrect": false, "duration": balloonDisplayTime},
      ];
      selectedBalloon = otherBalloons[
      ((probability - (0.5 + specialBalloonProbability)) / (0.5 / otherBalloons.length)).floor()];
    }

    final balloon = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "characterIndex": characterIndex,
      "x": characterPositions[characterIndex].dx + 80,
      "y": characterPositions[characterIndex].dy - 30,
      "image": selectedBalloon["image"] ?? "assets/images/default.png",
      "isCorrect": selectedBalloon["isCorrect"],
      "clicked": false, // 터치 여부 추적
    };

    setState(() {
      balloons.add(balloon);
    });

    // 말풍선 제거 타이머
    Timer(Duration(milliseconds: (selectedBalloon["duration"] * 1000).toInt()), () {
      if (mounted) {
        setState(() {
          // 말풍선을 삭제하기 전에 상태 확인
          Map<String, dynamic>? currentBalloon =
          balloons.firstWhere((b) => b["id"] == balloon["id"], orElse: () => {});
          if (currentBalloon.isNotEmpty && !currentBalloon["clicked"]) {
            // "어?" 또는 "헉!"이 자동으로 사라질 경우 게임 오버
            if (currentBalloon["isCorrect"]) {
              triggerGameOver();
            }
          }

          // 말풍선 제거
          balloons.removeWhere((b) => b["id"] == balloon["id"]);
          characterHasBalloon[characterIndex] = false;
        });
      }
    });
  }

  void onBalloonTap(int id, int characterIndex, bool isCorrect) {
    setState(() {
      // 풍선의 클릭 상태를 업데이트
      Map<String, dynamic>? currentBalloon =
      balloons.firstWhere((b) => b["id"] == id, orElse: () => {});
      if (currentBalloon.isNotEmpty) {
        currentBalloon["clicked"] = true;
      }

      // "어?" 또는 "헉!"이 아닌 풍선을 터치하면 게임 오버
      if (!isCorrect) {
        triggerGameOver();
      }

      // 풍선 제거
      balloons.removeWhere((b) => b["id"] == id);
      characterHasBalloon[characterIndex] = false;
    });
  }

  void triggerGameOver() {
    gameTimer.cancel();
    balloonTimer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UhWrongPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Stack(
        children: [
          // 상단 문구 표시
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Center(
              child: Text(
                widget.level >= 10
                    ? '절대 "헉!"이라고도 하지 마'
                    : '절대 "어?"를 말하지 마',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // 캐릭터 표시
          ...characterPositions.asMap().entries.map((entry) {
            int index = entry.key;
            Offset position = entry.value;
            return Positioned(
              top: position.dy,
              left: position.dx,
              child: Image.asset(
                'assets/images/person_with_pc_${index + 1}.png',
                width: 150,
                height: 150,
              ),
            );
          }).toList(),

          // 말풍선 표시
          ...balloons.map((balloon) {
            return Positioned(
              top: balloon["y"],
              left: balloon["x"],
              child: GestureDetector(
                onTap: () => onBalloonTap(
                  balloon["id"],
                  balloon["characterIndex"],
                  balloon["isCorrect"],
                ),
                child: Image.asset(
                  balloon["image"], // 말풍선 이미지 표시
                  width: 80,
                  height: 80,
                ),
              ),
            );
          }).toList(),
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

class UhWrongPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Wrong Page",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UhGamePage(level: 1), // 초기 레벨로 다시 시작
                  ),
                );
              },
              child: const Text("다시하기"),
            ),
          ],
        ),
      ),
    );
  }
}

class UhClearPage extends StatelessWidget {
  final int level;
  const UhClearPage({required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Clear Page - Level: $level",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UhGamePage(level: level + 1), // 다음 레벨로 진행
                  ),
                );
              },
              child: const Text("다시하기"),
            ),
          ],
        ),
      ),
    );
  }
}
