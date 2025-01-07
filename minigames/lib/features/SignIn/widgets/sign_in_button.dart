import 'package:flutter/material.dart';

import '../../../core/colors.dart';


class SignInButton extends StatelessWidget {
  final VoidCallback onPressed; // 버튼 클릭 시 수행할 액션

  const SignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          // ✅ 아래쪽 검은색 그림자
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),

        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: () {
          print("Sign in  Button Pressed");
          onPressed(); // ✅ 전달받은 콜백 실행
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.customBlue,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0, // ✅ 기본 Elevation 제거 (BoxDecoration 사용 중이므로 불필요)
        ),
        child: const Text(
          'SIGN UP',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
