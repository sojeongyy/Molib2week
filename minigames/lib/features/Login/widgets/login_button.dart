import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 처리를 위한 패키지
import '../../../core/colors.dart';
import 'package:minigames/features/Home/HomePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController idController; // ID 입력 컨트롤러
  final TextEditingController passwordController; // 비밀번호 입력 컨트롤러

  const LoginButton({
    super.key,
    required this.idController,
    required this.passwordController,
  });

  Future<void> _saveUserData(String userId, String nickname, bool isKakaoLinked, String profileImageUrl, int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('nickname', nickname);
    await prefs.setBool('isKakaoLinked', isKakaoLinked);
    await prefs.setString('profileImageUrl', profileImageUrl);
    await prefs.setInt('id', id);
  }

  Future<void> login(BuildContext context) async {
    print('로그인 시도: ${idController.text}, ${passwordController.text}');
    final String username = idController.text;
    final String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      print('입력값 검증 실패: 아이디 또는 비밀번호가 비어 있습니다.');
      _showSnackBar(context, '아이디와 비밀번호를 입력해주세요.');
      return;
    }

    try {
      // 서버로 로그인 요청
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
      print('API URL: $apiUrl');
      final response = await http.post(
        Uri.parse('$apiUrl/auth/login'), // 서버 URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      print('응답 상태 코드: ${response.statusCode}');
      print('응답 본문: ${response.body}');

      // 서버 응답 처리
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('로그인 성공: ${data['user']['nickname']}');

        final userId = data['user']['username'];
        final nickname = data['user']['nickname'];
        final isKakaoLinked = data['user']['is_kakao_linked'];
        final profileImageUrl = data['user']['profile_image_url'] ?? '';
        final id = data['user']['id'];

        // 유저 정보 저장
        await _saveUserData(userId, nickname, isKakaoLinked, profileImageUrl, id);

        // 로그인 성공 시 홈 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else if (response.statusCode == 401) {
        // 아이디 또는 비밀번호 오류
        final data = json.decode(response.body);
        print('로그인 실패 (401): ${data}');
        _showSnackBar(context, data['message']);
      } else {
        // 기타 서버 오류
        print('서버 오류: 상태 코드=${response.statusCode}');
        _showSnackBar(context, '서버 오류가 발생했습니다.');
      }
    } catch (e) {
      // 네트워크 오류 등 처리
      print('네트워크 오류: $e');
      _showSnackBar(context, '네트워크 오류가 발생했습니다.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    // 하단 팝업 바 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // 2초 동안 표시
        behavior: SnackBarBehavior.floating, // 하단에 살짝 떠 있는 디자인
      ),
    );
  }

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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomePage()),
            // );
            login(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.customBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'LOGIN',
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