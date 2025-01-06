import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import 'package:minigames/features/Home/HomePage.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // 버튼 너비 고정
      height: 50,
      child: DecoratedBox( // ✅ 그림자 효과를 위한 DecoratedBox 사용
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // ✅ 그림자 색상 및 투명도
              offset: const Offset(0, 2),           // ✅ 수직 그림자 위치 조정
              spreadRadius: 2,                       // ✅ 그림자 확산
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            print("로그인 버튼 클릭");
            // HomePage로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.customBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'login',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.almostWhite,
            ),
          ),
        ),
      ),
    );
  }
}
