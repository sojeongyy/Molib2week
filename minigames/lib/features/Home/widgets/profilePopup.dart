import 'package:flutter/material.dart';

class ProfilePopup extends StatelessWidget {
  final String nickname;
  final bool isKakaoLinked;
  final VoidCallback onKakaoLink;
  final VoidCallback onKakaoUnlink;

  const ProfilePopup({
    Key? key,
    required this.nickname,
    required this.isKakaoLinked,
    required this.onKakaoLink,
    required this.onKakaoUnlink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('프로필'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('닉네임: $nickname'),
          const SizedBox(height: 10),
          Text('카카오 연동: ${isKakaoLinked ? "연동됨" : "연동되지 않음"}'),
        ],
      ),
      actions: [
        if (!isKakaoLinked)
          ElevatedButton(
            onPressed: onKakaoLink,
            child: const Text('카카오 연동하기'),
          ),
        if (isKakaoLinked)
          ElevatedButton(
            onPressed: onKakaoUnlink,
            child: const Text('카카오 연결 끊기'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}
