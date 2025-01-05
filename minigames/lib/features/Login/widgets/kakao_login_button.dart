import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:minigames/features/Home/HomePage.dart';

class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({Key? key}) : super(key: key);

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
      String? profileImageUrl = user.kakaoAccount?.profile?.profileImageUrl;
      int? kakaoId = user.id; // 카카오 고유 ID
      print('사용자 닉네임: $nickname');
      print('프로필 사진 URL: $profileImageUrl');
      print('카카오 고유 ID: $kakaoId');

      // 홈 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(nickname: nickname ?? "사용자"),
        ),
      );
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
