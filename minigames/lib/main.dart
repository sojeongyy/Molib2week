import 'package:flutter/material.dart';
import 'features/BeforeLogin/BeforeLoginPage.dart';
import 'core/colors.dart';  // 색상 파일 임포트

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // 디버그 배너 제거
      title: '공대생 터치!',

      // 앱 전체 테마 설정 (app_colors.dart 활용)
      theme: ThemeData(
        primaryColor: AppColors.softBlue,  // 기본 색상 설정
        scaffoldBackgroundColor: AppColors.almostWhite,  // 배경색
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),

      // 첫 화면 지정
      home: BeforeLoginPage(),
    );
  }
}
