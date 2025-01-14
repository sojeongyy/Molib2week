import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:minigames/features/Home/HomePage.dart';
import 'package:minigames/features/SignIn/SignInPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({Key? key}) : super(key: key);

  Future<void> _saveUserData(String userId, String nickname, bool isKakaoLinked, String profileImageUrl, int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('nickname', nickname);
    await prefs.setBool('isKakaoLinked', isKakaoLinked);
    await prefs.setString('profileImageUrl', profileImageUrl);
    await prefs.setInt('id', id);
    await prefs.setBool('isKeepLoggedIn', true);
  }

  Future<void> _loginWithKakao(BuildContext context) async {
    try {
      // 카카오톡이 설치되어 있는지 확인
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } else {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오 계정으로 로그인 성공');
      }

      // 로그인 후 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      String? nickname = user.kakaoAccount?.profile?.nickname;
      int kakaoId = user.id; // 카카오 고유 ID
      String? profileImageUrl = user.kakaoAccount?.profile?.profileImageUrl; // 프로필 이미지 URL (회원가입 시 사용)

      print('사용자 닉네임: $nickname');
      print('카카오 고유 ID: $kakaoId');
      print('프로필 이미지 URL: $profileImageUrl');

      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

      // 서버로 로그인 요청
      final response = await http.post(
        Uri.parse('$apiUrl/auth/kakao/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'kakaoId': kakaoId.toString()}), // 로그인에 프로필 사진 전달하지 않음
      );

      if (response.statusCode == 200) {
        // 로그인 성공
        final data = json.decode(response.body);
        final String nickname = data['user']['nickname'];
        final bool isKakaoLinked = data['user']['is_kakao_linked'];
        print('로그인 성공: 닉네임=$nickname');

        final userId = data['user']['username'];
        final id = data['user']['id'];

        // 유저 정보 저장
        await _saveUserData(userId, nickname, isKakaoLinked, profileImageUrl ?? '', id);

        // 홈 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else if (response.statusCode == 404) {
        // 유저가 없으므로 회원가입 필요
        print('회원가입 필요');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입이 필요합니다.')),
        );

        // 회원가입 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(
              kakaoId: kakaoId.toString(),
              defaultNickname: nickname ?? '사용자',
              profileImageUrl: profileImageUrl ?? '', // 회원가입 시 프로필 사진 전달
            ),
          ),
        );
      } else {
        // 기타 오류
        print('서버 오류: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서버 오류가 발생했습니다.')),
        );
      }
    } catch (error) {
      print('카카오 로그인 실패: $error');
      // 실패 메시지를 사용자에게 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _loginWithKakao(context),
      child: Image.asset(
        'assets/images/kakao_login.png',
        width: 300,
      ),
    );
  }
}
