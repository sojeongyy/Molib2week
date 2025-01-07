import 'package:flutter/material.dart';
import 'package:minigames/core/colors.dart';
import '../../core/NextButton.dart';

class UhClearPage extends StatelessWidget {

  final int level;
  const UhClearPage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customBlue, // 배경색
      body: Stack(
        children: [
          // ✅ 배경 이미지 (중앙 정렬)
          Center(
            child: Image.asset(
              'assets/images/Uh_success.png',
              width: 300,                  // 이미지 크기 조정
              fit: BoxFit.contain,         // 이미지 비율 유지
            ),
          ),
          Center(
            child: NextButton(level: level),
          ),
        ],
      ),
    );
  }
}

