import 'package:flutter/material.dart';
import 'package:minigames/features/Home/HomePage.dart';
import 'package:minigames/features/Login/LoginPage.dart';
import '../../../core/colors.dart';

class NextButton extends StatelessWidget {

  final int level;
  const NextButton({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      onPressed: () {
        print("next 버튼 클릭");
        print(level);
        startRandomGame(context, 1, level+1);
      },

      style: ElevatedButton.styleFrom(
        backgroundColor:AppColors.softBlue,
        // 높이 조절
        minimumSize: const Size(155, 74), // 너비, 높이
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),

        ),
      ),
      child: const Text(
        'Next',
        style: TextStyle(fontSize: 32, color: AppColors.almostWhite),
      ),
    );
  }
}