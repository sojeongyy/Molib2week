import 'package:flutter/material.dart';
import 'package:minigames/core/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../SignIn/SignInPage.dart'; // SignInPage import 추가
import '../../../core/colors.dart'; // AppColors import 추가

// 로그인 유지 버튼 상태를 관리
class LoginForm extends StatefulWidget {
  final TextEditingController idController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.idController,
    required this.passwordController,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isKeepLoggedIn = false; // 로그인 유지 여부

  void _toggleKeepLoggedIn() {
    setState(() {
      _isKeepLoggedIn = !_isKeepLoggedIn; // 상태 변경
    });
    _saveKeepLoggedIn(_isKeepLoggedIn); // 상태를 SharedPreferences에 저장
  }

  Future<void> _saveKeepLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isKeepLoggedIn', value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 아이디 입력 필드
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: widget.idController,
            decoration: InputDecoration(
              hintText: '아이디',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 2, color: AppColors.customBlue),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 비밀번호 입력 필드
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: widget.passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: '비밀번호',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 2, color: AppColors.customBlue),
              ),
            ),
          ),
        ),

        // 회원가입 및 로그인 유지 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                // 회원가입 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              child: const Text('회원가입'),
            ),
            TextButton(
              onPressed: _toggleKeepLoggedIn, // 상태 토글
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              child: Text(
                '로그인 유지',
                style: TextStyle(
                  color: _isKeepLoggedIn
                      ? AppColors.customBlue // 활성화 시 색상
                      : Colors.black, // 비활성화 시 색상
                  //fontWeight: FontWeight.bold, // 글씨 강조
                ),
              ),
            ),

          ],
        ),
      ],
    );
  }
}
