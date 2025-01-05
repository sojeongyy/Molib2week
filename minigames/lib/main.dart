import 'package:flutter/material.dart';
import 'package:minigames/features/CoupleGame/CoupleGamePage.dart';
import 'features/BeforeLogin/BeforeLoginPage.dart';
import 'core/colors.dart';  // 색상 파일 임포트
import 'core/BackgroundMusicManager.dart'; // 배경 음악 매니저 불러오기

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    BackgroundMusicManager.startBackgroundMusic();

    return MaterialApp(
      debugShowCheckedModeBanner: false,  // 디버그 배너 제거
      title: '공대생 터치!',

      // 앱 전체 테마 설정 (app_colors.dart 활용)
      theme: ThemeData(
        primaryColor: AppColors.softBlue,  // 기본 색상 설정
        scaffoldBackgroundColor: AppColors.almostWhite,  // 배경색
        fontFamily: 'Inter-24pt-Black', // 기본 폰트 설정
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),

      // 첫 화면 지정
      home: CoupleGamePage(),
    );
  }
}
