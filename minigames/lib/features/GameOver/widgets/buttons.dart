import 'package:flutter/material.dart';
import '../../../core/BackgroundMusicManager.dart';
import '../../../core/ScoreManager.dart';
import '../../../core/colors.dart';
import '../../Home/HomePage.dart';

class Buttons extends StatelessWidget {
  final ScoreManager scoreManager;

  const Buttons({super.key, required this.scoreManager});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // ✅ 버튼을 가운데 정렬
      children: [
        // ✅ HOME 버튼
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // ✅ 그림자 설정
                offset: const Offset(0, 4),
                spreadRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: () {
              scoreManager.resetScore();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.customBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0, // ✅ 기본 Elevation 제거
            ),
            child: const Text(
              'HOME',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20), // ✅ 버튼 간 간격 추가

        // ✅ RETRY 버튼
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // ✅ 그림자 설정
                offset: const Offset(0, 4),
                spreadRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: () {
              BackgroundMusicPage.stop();
              scoreManager.resetScore();
              startRandomGame(context, 1, 1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.customBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0, // ✅ 기본 Elevation 제거
            ),
            child: const Text(
              'RETRY',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
