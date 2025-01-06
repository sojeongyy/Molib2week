import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:minigames/features/Home/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  final String? kakaoId; // 카카오 ID
  final String? defaultNickname; // 카카오 닉네임 (초기값)

  const SignInPage({Key? key, this.kakaoId, this.defaultNickname})
      : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _nicknameController =
        TextEditingController(text: widget.defaultNickname ?? ''); // 닉네임 초기값 설정
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _saveUserData(String userId, String nickname, bool isKakaoLinked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('nickname', nickname);
    await prefs.setBool('isKakaoLinked', isKakaoLinked);
  }

  Future<void> register() async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
    final registerUrl = widget.kakaoId != null
        ? Uri.parse('$apiUrl/auth/kakao/register') // 카카오 회원가입
        : Uri.parse('$apiUrl/auth/register'); // 일반 회원가입

    final loginUrl = Uri.parse('$apiUrl/auth/login'); // 로그인 API

    final requestBody = widget.kakaoId != null
        ? {
            "kakaoId": widget.kakaoId,
            "username": _usernameController.text,
            "password": _passwordController.text,
            "nickname": _nicknameController.text,
          }
        : {
            "username": _usernameController.text,
            "password": _passwordController.text,
            "nickname": _nicknameController.text,
          };

    try {
      // 회원가입 요청
      final registerResponse = await http.post(
        registerUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (registerResponse.statusCode == 201) {
        // 회원가입 성공, 바로 로그인 요청
        final loginResponse = await http.post(
          loginUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "username": _usernameController.text,
            "password": _passwordController.text,
          }),
        );

        if (loginResponse.statusCode == 200) {
          final loginData = json.decode(loginResponse.body);
          final nickname = loginData['user']['nickname'];

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인 성공!')),
          );

          final userId = loginData['user']['username'];
          final isKakaoLinked = loginData['user']['is_kakao_linked'];

          // 유저 정보 저장
          await _saveUserData(userId, nickname, isKakaoLinked);

          // 홈 화면으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 실패: ${loginResponse.body}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${registerResponse.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: '아이디'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: '닉네임'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
