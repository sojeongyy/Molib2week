import 'package:flutter/material.dart';
import 'package:minigames/core/colors.dart';
import 'widgets/login_button.dart';
import 'widgets/login_form.dart';
import 'widgets/background_image.dart';
import 'widgets/kakao_login_button.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 노치 디바이스 및 화면 경계 보호
        child: Stack(
          children: [
            // 배경 이미지 (고정)
            const BackgroundImage(),

            // 스크롤 가능하게 수정된 로그인 폼과 텍스트
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 110),
                  Center(  // 텍스트도 가운데 정렬
                    child: Image.asset('assets/images/title.png', width: 300),
                  ),
                  // 제목 텍스트
                  // const Text(
                  //   'DUMB WAYS\nTO DIE',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 50,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //     height: 1
                  //   ),
                  // ),
                  const SizedBox(height: 50),

                  // 로그인 폼 (아이디/비밀번호 입력)
                  LoginForm(
                    idController: idController,
                    passwordController: passwordController,
                  ),
                  const SizedBox(height: 10),

                  LoginButton(
                    idController: idController,
                    passwordController: passwordController,
                  ),
                  const SizedBox(height: 10),
                  // 카카오 로그인 버튼
                  const KakaoLoginButton(),
                  const SizedBox(height: 10),

                ],
              ),
            ),

            // 캐릭터 이미지 (하단 중앙 고정)
            // Align(
            //   alignment: Alignment.bottomCenter, // 하단 중앙에 고정
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 20),
            //     child: Image.asset(
            //       'assets/images/blue_person.png',
            //       width: 150,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
