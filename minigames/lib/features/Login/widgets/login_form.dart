import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController idController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.idController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 아이디 입력 필드
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // 좌우 20만큼의 여백 ,
          child: TextField(
            controller: idController,
            decoration: InputDecoration(
              hintText: '아이디',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10), // 10만큼의 여백

        // 비밀번호 입력 필드
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: passwordController,
            obscureText: true,  // 비밀번호 숨김
            decoration: InputDecoration(
              hintText: '비밀번호',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),

        const SizedBox(height: 3),

        // 회원가입 및 비밀번호 찾기 텍스트
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(onPressed: () {}, child: const Text('회원가입')),
            TextButton(onPressed: () {}, child: const Text('아이디/비밀번호 찾기')),
          ],
        ),
      ],
    );
  }
}
