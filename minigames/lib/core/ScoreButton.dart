import 'package:flutter/material.dart';

import 'colors.dart';

class ScoreButton extends StatelessWidget {
  final VoidCallback onPressed; // ✅ 버튼 클릭 시 실행할 함수
  const ScoreButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,  // ✅ 화면의 오른쪽 하단에 위치
      right: 20,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          backgroundColor: AppColors.beige,  // ✅ 버튼 색상
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text(
          'Check Your Score',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
