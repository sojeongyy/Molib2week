import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print("로그인 버튼 클릭");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:AppColors.almostWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        'login',
        style: TextStyle(fontSize: 32, color: AppColors.softBlue),
      ),
    );
  }
}