import 'package:flutter/material.dart';
import 'package:minigames/features/Home/HomePage.dart';
import '../../../core/colors.dart';

class NextButton extends StatelessWidget {
  final int level;
  const NextButton({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight, // ✅ 오른쪽 하단 정렬
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20), // ✅ 위치 미세 조정
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.customYellow,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 5),
                spreadRadius: 2,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              print("Next 버튼 클릭");
              print(level);
              startRandomGame(context, 1, level + 1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                'Next',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
