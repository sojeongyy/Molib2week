import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,  // 화면 전체 너비
        height: double.infinity, // 화면 전체 높이
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_image.jpg'), // ✅ 이미지 경로
            fit: BoxFit.cover, // ✅ 이미지 크기 조정 (화면 가득 채움)
          ),
        ),

      ),
    );
  }
}
