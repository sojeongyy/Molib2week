import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:minigames/features/RunGame/CollisionPage.dart';
import 'package:minigames/features/RunGame/NotCollisionPage.dart';
import '../../core/Timer.dart';

class RunGamePage extends StatefulWidget {
  final int level;
  const RunGamePage({super.key, required this.level});

  @override
  _RunGamePageState createState() => _RunGamePageState();
}

class _RunGamePageState extends State<RunGamePage> with SingleTickerProviderStateMixin {
  double professorX = 100;
  double professorY = 100;
  double playerX = 200;
  double playerY = 400;
  final double blue_person_width = 100;
  final double professor_width = 180;
  bool isGameOver = false;
  late AnimationController _controller;
  late TimerManager timerManager;
  double speed = 300;
  int gameDuration = 5;
  late Future<void> _delayedTransition; // ✅ 추가
  bool _isDisposed = false; // ✅ 추가

  @override
  void initState() {
    super.initState();
    speed += widget.level * 50;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(() {
      moveProfessorTowardsPlayer();
    });
    _controller.repeat();

    timerManager = TimerManager(
      context: context,
      duration: gameDuration,
      controller: _controller,
      onComplete: () {
        if (!isGameOver && mounted) {
          setState(() {
            isGameOver = true;
            _controller.stop();
          });
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NotCollisionPage(level: widget.level)),
              );
            }
          });
        }
      },
      onUpdate: (timeLeft) {
        if (mounted) setState(() {});
      },
    );

    timerManager.startTimer();
  }

  void moveProfessorTowardsPlayer() {
    setState(() {
      double dx = playerX - professorX;
      double dy = playerY - professorY;
      double distance = sqrt(dx * dx + dy * dy);
      if (distance > 1) {
        professorX += (dx / distance) * (speed * 0.01);
        professorY += (dy / distance) * (speed * 0.01);
      }
      checkCollision();
    });
  }

  void checkCollision() {
    double professorRadius = professor_width / 2;
    double bluePersonRadius = blue_person_width / 2;
    double dx = playerX + bluePersonRadius - (professorX + professorRadius);
    double dy = playerY + bluePersonRadius - (professorY + professorRadius);
    double distance = sqrt(dx * dx + dy * dy);

    bool isColliding = distance < (professorRadius + bluePersonRadius) * 0.8;

    if (isColliding) {
      setState(() {
        isGameOver = true;
        _controller.stop();
        timerManager.cancelTimer();
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) { // ✅ context.mounted 체크 추가
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CollisionPage()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6464),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 0,
            child: buildProgressBar(timerManager.timeLeft, gameDuration),
          ),
          Positioned(
            top: professorY,
            left: professorX,
            child: Image.asset('assets/images/professor.png', width: professor_width),
          ),
          Positioned(
            top: playerY,
            left: playerX,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  playerX += details.delta.dx;
                  playerY += details.delta.dy;
                  checkCollision();
                });
              },
              child: Image.asset('assets/images/blue_person.png', width: blue_person_width),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: const Text('교수님으로부터 run!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true; // ✅ Dispose 상태 체크 추가
    timerManager.dispose();  // ✅ TimerManager에서 dispose 호출
    _controller.dispose();  // ✅ 애니메이션 컨트롤러 해제
    super.dispose();
  }
}
