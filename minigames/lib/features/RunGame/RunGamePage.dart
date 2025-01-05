import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:minigames/features/RunGame/CollisionPage.dart';

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
  final double blue_person_height = 100;
  final double professor_width = 180;
  final double professor_height = 180;
  bool isGameOver = false;
  late AnimationController _controller;
  double speed = 300; // Control the speed of movement

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

    bool isColliding = distance < (professorRadius + bluePersonRadius) * 0.8; // Reduced collision sensitivity

    if (isColliding) {
      setState(() {
        isGameOver = true;
        _controller.stop();
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
      backgroundColor: const Color(0xFFFF6464), // 배경색
      body: Stack(
        children: [
          Positioned(
            top: professorY,
            left: professorX,
            child: Image.asset('assets/images/professor.png', width: professor_width, height: professor_height),
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
              child: Image.asset('assets/images/blue_person.png', width: blue_person_width, height: blue_person_height),
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
    super.dispose();
  }
}

