import 'package:flutter/material.dart';
import '../../../core/ScoreManager.dart';
import '../../../core/colors.dart';
import '../../Home/HomePage.dart';

class Score extends StatelessWidget {
  final List<int> scores;
  final ScoreManager scoreManager;
  const Score({super.key, required this.scores, required this.scoreManager});

  @override
  Widget build(BuildContext context) {
    // 상위 3개의 점수만 표시 (내림차순 정렬 후 상위 3개 선택)
    final topScores = (scores..sort((a, b) => b.compareTo(a))).take(3).toList();

    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 타이틀 : SCOREBOARD
          Container(
            width: 300,
            padding: const EdgeInsets.all(10), // 내부 여백 추가
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'SCORE : ${scoreManager.score}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Inter-24pt-Black',
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 정확히 3등분하는 상자
          Container(
            height: 171,
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // 1등
                Expanded(
                  child: Center(
                    child: Text(
                      topScores[0].toString(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // 첫 번째 선
                const Divider(
                  color: AppColors.beige,
                  thickness: 1.5,
                  height: 0, // 높이 0으로 설정하여 선만 표시
                ),
                // 2등
                Expanded(
                  child: Center(
                    child: Text(
                      topScores[1].toString(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // 두 번째 선
                const Divider(
                  color: AppColors.beige,
                  thickness: 1.5,
                  height: 0,
                ),
                // 3등
                Expanded(
                  child: Center(
                    child: Text(
                      topScores[2].toString(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
