import 'package:flutter/material.dart';
import 'package:minigames/core/colors.dart';
import 'widgets/login_form.dart';
import 'widgets/background_image.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.almostWhite,
      body: Stack(
        children: [
          // 배경 이미지
          BackgroundImage(),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),

              // 제목 텍스트
              const Text(
                'DUMB WAYS\nto be 공머생',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),

              // 로그인 폼
              LoginForm(
                idController: idController,
                passwordController: passwordController,
              ),
              const SizedBox(height: 20), // 20만큼의 여백

            ],
          ),
          // 캐릭터 이미지 (Positioned 사용)
          Positioned(
            bottom: 10,  // 화면 하단에서 10px 위
            //left: 100,
            child: Center(
              child: Image.asset(
                'assets/images/blue_person.png',
                width: 150,
              ),
            ),
          ),
        ]
      )
    );
  }
}