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
        if (!isKakaoLinked) // ✅ 카카오 연동 버튼
          ElevatedButton(
            onPressed: onKakaoLink,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.customYellow,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              '카카오 연동하기',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        if (isKakaoLinked) // ✅ 카카오 연결 해제 버튼
          ElevatedButton(
            onPressed: onKakaoUnlink,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.customYellow,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              '카카오 연결 끊기',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
