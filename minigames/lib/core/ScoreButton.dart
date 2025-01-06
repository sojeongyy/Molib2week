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
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GameOverPage(scoreManager: scoreManager)),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          backgroundColor: AppColors.beige,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text(
          'Check your score',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
