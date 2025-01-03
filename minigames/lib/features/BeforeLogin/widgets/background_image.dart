import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/school.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 캐릭터 배치 (Positioned 사용)
          Positioned(
            top: 200,
            left: 30,
            child: Image.asset('assets/images/blue_person.png', width: 100),
          ),
          Positioned(
            top: 200,
            right: 30,
            child: Image.asset('assets/images/brown_person.png', width: 100),
          ),
          Positioned(
            bottom: 100,
            left: 50,
            child: Image.asset('assets/images/green_person.png', width: 100),
          ),
          Positioned(
            bottom: 100,
            right: 50,
            child: Image.asset('assets/images/yellow_person.png', width: 100),
          ),

        ],
      ),
    );
  }
}
