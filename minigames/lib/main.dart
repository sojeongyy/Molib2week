import 'package:flutter/material.dart';
import 'features/BeforeLogin/BeforeLoginPage.dart';
import 'core/colors.dart'; // 색상 파일 임포트
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart'; // 카카오 SDK 임포트
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 초기화
  await dotenv.load(); // .env 파일 로드
  try {
    await dotenv.load(fileName: ".env"); // 기본적으로 루트 디렉토리에서 찾음
  } catch (e) {
    print("Error loading .env file: $e");
  }
  KakaoSdk.init(nativeAppKey: dotenv.env['NATIVE_APP_KEY']!);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      title: '공대생 터치!',

      // 앱 전체 테마 설정 (app_colors.dart 활용)
      theme: ThemeData(
        primaryColor: AppColors.softBlue, // 기본 색상 설정
        scaffoldBackgroundColor: AppColors.almostWhite, // 배경색
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),

      // 첫 화면 지정
      home: BeforeLoginPage(),
    );
  }
}
