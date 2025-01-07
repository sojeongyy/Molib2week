import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:minigames/core/colors.dart';
import 'dart:async';
import 'dart:math';
import '../../core/ScoreManager.dart';
import '../../core/Timer.dart';
import 'UhClearPage.dart';
import 'UhWrongPage.dart';

class UhGamePage extends StatefulWidget {
  final int level; // 난이도: 말풍선의 개수와 표시 시간 조정
  final ScoreManager scoreManager;

  const UhGamePage({super.key, required this.level, required this.scoreManager});

  @override
  State<UhGamePage> createState() => _UhGamePageState();
}

class _UhGamePageState extends State<UhGamePage> with SingleTickerProviderStateMixin{
  final List<Map<String, dynamic>> balloons = [];
  final Random random = Random();
  int balloonsCaught = 0;
  int balloonsMissed = 0;
  late TimerManager timerManager;
  late Timer balloonTimer;
  int gameDuration = 7; // 총 게임 시간
  late int maxBalloons;
  double balloonDisplayTime = 1.0;
  late AnimationController _controller;
  bool _isDisposed = false;

  // ✅ 오디오 플레이어 추가
  final AudioPlayer _audioPlayer = AudioPlayer();

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

    // ✅ 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // TimerManager 초기화
    timerManager = TimerManager(
      context: context,
      duration: gameDuration,
      controller: _controller,
      onComplete: () {
        if (mounted) {  // ✅ mounted 체크 추가
          widget.scoreManager.addPoints(100); // ✅ 100점 추가
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UhClearPage(level: widget.level)),
          );
        }
      },
      onUpdate: (timeLeft) {
        if (mounted) setState(() {});
      },
    );

    // 난이도에 따른 말풍선 설정
    maxBalloons = 2 + (widget.level ~/ 5); // 레벨 5마다 1씩 증가, 최대 6
    balloonDisplayTime = max(1.0, 2.5 - widget.level * 0.1); // 말풍선 표시 시간

    timerManager.startTimer();
    // 게임 시작
    startGame();
  }

  // ✅ 음원 재생 메서드 추가
  Future<void> _playSound(String soundFile) async {
    try {
      await _audioPlayer.setSource(AssetSource('audios/$soundFile'));
      await _audioPlayer.resume();
    } catch (e) {
      print("음원 재생 실패: $e");
    }
  }

  void startGame() {
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
      _playSound('Huk.mp3'); // ✅ "헉!" 사운드 재생
    } else if (probability < 0.5 + specialBalloonProbability) {
      selectedBalloon = {
        "image": "assets/images/Uh.png",
        "isCorrect": true,
        "duration": balloonDisplayTime,
      };
      _playSound('Uh.mp3'); // ✅ "어?" 사운드 재생
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
    // gameTimer.cancel();
    balloonTimer.cancel();

    // ✅ 진행 시간 계산
    double elapsedTime = gameDuration - timerManager.timeLeft;
    double progressRatio = elapsedTime / gameDuration;
    int additionalPoints = (100 * progressRatio).round(); // ✅ 점수 계산 및 반올림

    // ✅ 점수 추가
    widget.scoreManager.addPoints(additionalPoints);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UhWrongPage(scoreManager: widget.scoreManager)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customBlue,
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 0,
            child: buildProgressBar(timerManager.timeLeft, gameDuration),
          ),
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
    _isDisposed = true; // ✅ Dispose 플래그 설정
    timerManager.dispose(); // ✅ 타이머 해제
    balloonTimer.cancel(); // ✅ 타이머 해제
    _controller.dispose(); // ✅ 애니메이션 컨트롤러 해제
    _audioPlayer.dispose(); // ✅ 오디오 플레이어 해제
    super.dispose();
  }
}

