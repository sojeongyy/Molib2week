import 'package:flutter/material.dart';
import 'package:minigames/core/colors.dart';

class BackgroundImage extends StatelessWidget {

  // const 생성자 추가 (정적 위젯으로 만듦)
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.almostWhite), // 배경색 추가

        // 학교 이미지 배치 (Positioned 사용)
        Positioned(
          top: -100,  // 이미지를 위로 50픽셀 이동
          left: 0,
          right: 0,
          child: Image.asset('assets/images/school.png', fit: BoxFit.fitWidth),
        ),
      ],
    );
  }
}
