import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class KakaoButton extends StatelessWidget {
  final bool isKakaoLinked;
  final VoidCallback onKakaoLink;
  final VoidCallback onKakaoUnlink;

  const KakaoButton({
    Key? key,
    required this.isKakaoLinked,
    required this.onKakaoLink,
    required this.onKakaoUnlink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // ✅ 버튼을 내용 크기에 맞춤
      children: [
        // ✅ 카카오 연동 버튼 (그림자 추가)
        if (!isKakaoLinked)
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.customYellow,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // ✅ 그림자 색상
                  offset: const Offset(0, 3),           // ✅ 그림자 위치
                  spreadRadius: 2,                     // ✅ 퍼짐 정도
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onKakaoLink,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // ✅ 색상 투명 (DecoratedBox로 설정)
                elevation: 0, // ✅ 버튼 자체의 기본 그림자 제거
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'LINK KAKAO',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        const SizedBox(height: 10), // 버튼 간 여백 추가
        // ✅ 카카오 연결 해제 버튼 (그림자 추가)
        if (isKakaoLinked)
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.customYellow,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 3),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onKakaoUnlink,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0, // ✅ 기본 그림자 제거
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'UNLINK KAKAO',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
