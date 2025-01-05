import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import 'package:minigames/features/Home/HomePage.dart';

class LoginButton extends StatelessWidget {
  //final VoidCallback onPressed; // 버튼 클릭 시 수행할 액션

  //const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // 버튼 너비 고정
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          print("로그인 버튼 클릭");
          // LoginPage로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(nickname: "사용자")), // 직접 페이지 지정
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.softBlue,
          //padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'login',
          //중앙 정렬
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            //fontWeight: FontWeight,
            color: AppColors.almostWhite,
          ),
        ),
      ),
    );
  }
}
