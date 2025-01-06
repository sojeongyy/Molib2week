import 'package:flutter/material.dart';
import '../../core/ScoreManager.dart';
import '../features/GameOver/GameOverPage.dart';
import 'colors.dart';

class ScoreButton extends StatelessWidget {
  final ScoreManager scoreManager; // ✅ ScoreManager를 매개변수로 받음

  const ScoreButton({super.key, required this.scoreManager});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: DecoratedBox( // ✅ 그림자 추가
        decoration: BoxDecoration(
          color: AppColors.customYellow,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // ✅ 그림자 색상 및 투명도
              offset: const Offset(0, 2),           // ✅ 수직 그림자 위치 조정
              spreadRadius: 2,                      // ✅ 그림자 확산
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GameOverPage(scoreManager: scoreManager)),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // ✅ 배경 제거 (위 BoxDecoration이 대신함)
            elevation: 0,                        // ✅ 기본 Elevation 제거
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'Check your score',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
