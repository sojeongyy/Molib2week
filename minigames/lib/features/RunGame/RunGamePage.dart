import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:minigames/features/RunGame/CollisionPage.dart';

import '../../core/colors.dart';

class RunGamePage extends StatefulWidget {
  @override
  _RunGamePageState createState() => _RunGamePageState();
}

class _RunGamePageState extends State<RunGamePage> with SingleTickerProviderStateMixin {
  double professorX = 100;
  double professorY = 100;
  double playerX = 200;
  double playerY = 400;
  final double blue_person_width = 100;
  // final double blue_person_height = 100;
  final double professor_width = 180;
  // final double professor_height = 180;
  bool isGameOver = false;
  late AnimationController _controller;
  double speed = 300;
  int gameDuration = 5;
  late Timer _successTimer;
  double timeLeft = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 16),
    )..addListener(() {
      moveProfessorTowardsPlayer();
    });
    _controller.repeat();

    startTimer(gameDuration);
  }

  void startTimer(int duration) {
    timeLeft = duration.toDouble();
    _successTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft -= 0.1;
        });
      } else {
        if (!isGameOver) {
          setState(() {
            isGameOver = true;
            _controller.stop();
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SuccessPage()),
          );
        }
        timer.cancel();
      }
    });
  }

  Widget buildProgressBar() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      width: max(1, MediaQuery.of(context).size.width * (1 - (timeLeft / gameDuration))),
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.softBlue,
      ),
    );
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
        _successTimer.cancel();
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CollisionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6464),
      body: Stack(
        children: [
          Positioned(top: 20, left: 0, child: buildProgressBar()),
          Positioned(
            top: professorY,
            left: professorX,
            child: Image.asset('assets/images/professor.png', width: professor_width,),
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
              child: Image.asset('assets/images/blue_person.png', width: blue_person_width,),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Text('교수님으로부터 run!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _successTimer.cancel();
    super.dispose();
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Success!')),
      body: Center(
        child: Text('축하합니다! 성공하셨습니다!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
