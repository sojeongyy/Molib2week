import 'package:flutter/material.dart';


class CollisionPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6464), // 배경색
      body: Stack(
        children: [
          Positioned(
            bottom: 250,
            right: -200,
            child: Image.asset('assets/images/professor.png', width: 600),
          ),
          Positioned(
            bottom: 70,
            right: -100,
            child: Image.asset('assets/images/computer.png', width: 430),
          ),

          Positioned(
            bottom: 0,
            left: -50,
            child: Image.asset('assets/images/cryingperson.png', width: 380),
          ),
        ],
      ),
    );
  }
}