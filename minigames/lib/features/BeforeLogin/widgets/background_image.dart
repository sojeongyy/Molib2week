import 'package:flutter/material.dart';
import 'package:minigames/core/colors.dart';

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경색 변경
      backgroundColor: AppColors.almostWhite,
      body: Stack(
        children: [
          // 배경 이미지
          // 학교 배경 이미지 (크기 확대 및 위치 고정)
          Positioned(
            top: -50,  // 이미지를 위로 살짝 올리기
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/school.png',
              width: 700, // 가로 크기 확대 (높이는 비율에 맞춰 조정)
              //fit: BoxFit.fitWidth,  // 가로를 꽉 채우기
            ),
          ),

          // 캐릭터 배치 (Positioned 사용)
          Positioned(
            bottom: 240,
            left: 25,
            child: Image.asset('assets/images/blue_person.png', width: 130),
          ),
          Positioned(
            bottom: 220,
            right: 21,
            child: Image.asset('assets/images/brown_person.png', width: 130),
          ),
          Positioned(
            bottom: 70,
            left: 40,
            child: Image.asset('assets/images/green_person.png', width: 130),
          ),
          Positioned(
            bottom: 60,
            right: 40,
            child: Image.asset('assets/images/yellow_person.png', width: 130),
          ),

        ],
      ),
    );
  }
}
