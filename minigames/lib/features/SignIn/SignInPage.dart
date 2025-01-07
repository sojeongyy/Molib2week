import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:minigames/core/colors.dart';
import 'dart:convert';
import 'package:minigames/features/Home/HomePage.dart';
import 'package:minigames/features/SignIn/widgets/sign_in_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  final String? kakaoId; // 카카오 ID
  final String? defaultNickname; // 카카오 닉네임 (초기값)
  final String? profileImageUrl; // 카카오 프로필 이미지 URL

  const SignInPage({
    Key? key,
    this.kakaoId,
    this.defaultNickname,
    this.profileImageUrl,
  }) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController = TextEditingController();
  late final TextEditingController _nicknameController;

  bool _isPasswordMismatch = false;

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

  Future<void> _saveUserData(String userId, String nickname, bool isKakaoLinked, String profileImageUrl, int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('nickname', nickname);
    await prefs.setBool('isKakaoLinked', isKakaoLinked);
    await prefs.setString('profileImageUrl', profileImageUrl);
    await prefs.setInt('id', id);
  }

  Future<void> register() async {
    setState(() {
      _isPasswordMismatch = _passwordController.text != _confirmPasswordController.text;
    });

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
      "profileImageUrl": widget.profileImageUrl ?? '', // 프로필 이미지 URL 추가
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
          final profileImageUrl = loginData['user']['profile_image_url'] ?? '';
          final id = loginData['user']['id'];

          // 유저 정보 저장
          await _saveUserData(userId, nickname, isKakaoLinked, profileImageUrl, id);

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
      appBar: AppBar(
          title: const Text('Sign Up'),
          backgroundColor: AppColors.almostWhite,
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.profileImageUrl != null && widget.profileImageUrl!.isNotEmpty)
              Column(
                children: [
                  Image.network(widget.profileImageUrl!, width: 100, height: 100),
                  const SizedBox(height: 10),
                ],
              ),
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
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: '비밀번호 확인'),
            ),
            if (_isPasswordMismatch) // 비밀번호 불일치 시 경고 메시지 표시
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '비밀번호가 일치하지 않습니다.',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: '닉네임'),
            ),
            const SizedBox(height: 100),
            // ElevatedButton(
            //   onPressed: register,
            //   child: const Text('회원가입'),
            // ),

            SignInButton(onPressed: register)
          ],
        ),
      ),
      ),
    );
  }
}