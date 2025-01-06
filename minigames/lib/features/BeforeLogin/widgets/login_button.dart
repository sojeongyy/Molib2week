import 'package:flutter/material.dart';
import 'package:minigames/features/Login/LoginPage.dart';
import '../../../core/colors.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // ✅ 검은색 그림자
            offset: const Offset(0, 4),          // ✅ 수직 그림자
            spreadRadius: 2,                      // ✅ 확산 정도
          ),
        ],
        borderRadius: BorderRadius.circular(20),  // ✅ 버튼 모서리와 그림자 모서리를 일치시킴
      ),
      child: ElevatedButton(
        onPressed: () {
          print("로그인 버튼 클릭 - 홈 화면으로 이동");
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.customBlue,
          minimumSize: const Size(155, 74),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0, // ✅ 기본 elevation 제거
        ),
        child: const Text(
          'login',
          style: TextStyle(fontSize: 32, color: AppColors.almostWhite),
        ),
      ),
    );
  }
}
