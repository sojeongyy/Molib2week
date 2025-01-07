import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import 'cancel_button.dart';
import 'kakao_button.dart';

class ProfilePopupPage extends StatelessWidget {
  final String nickname;
  final bool isKakaoLinked;
  final VoidCallback onKakaoLink;
  final VoidCallback onKakaoUnlink;

  const ProfilePopupPage({
    Key? key,
    required this.nickname,
    required this.isKakaoLinked,
    required this.onKakaoLink,
    required this.onKakaoUnlink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog( // ✅ 다이얼로그로 변경
      backgroundColor: AppColors.customPink,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
      children: [
        Padding(
        padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ 팝업 크기 자동 조정
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/default_profile.png'),
              ),
              const SizedBox(height: 20),
              Text(
                nickname,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // ✅ KakaoButton 사용 (NextButton 스타일 반영)
              KakaoButton(
                isKakaoLinked: isKakaoLinked,
                onKakaoLink: onKakaoLink,
                onKakaoUnlink: onKakaoUnlink,
              ),
            ],
          ),
        ),
        const CancelButton(), // ✅ 원형 취소버튼 추가
      ],
      ),
    );
  }
}