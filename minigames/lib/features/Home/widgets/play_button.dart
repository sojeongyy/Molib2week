import 'package:flutter/material.dart';
import '../../../core/ScoreManager.dart';
import '../../../core/colors.dart';

class PlayButton extends StatelessWidget {
  final VoidCallback onPressed; // 버튼 클릭 시 수행할 액션
  final ScoreManager scoreManager; // 점수 관리자 사용

  const PlayButton({
    super.key,
    required this.onPressed,
    required this.scoreManager,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          // ✅ 아래쪽 검은색 그림자
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),

        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: () {
          print("Play Button Pressed");
          scoreManager.resetScore(); // ✅ 점수 초기화
          onPressed(); // ✅ 전달받은 콜백 실행
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.customBlue,
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0, // ✅ 기본 Elevation 제거 (BoxDecoration 사용 중이므로 불필요)
        ),
        child: const Text(
          'PLAY',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
