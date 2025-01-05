import 'package:flutter/material.dart';
import 'package:minigames/features/CoupleGame/CoupleGamePage.dart';
import 'package:audioplayers/audioplayers.dart';  // 오디오플레이어 임포트
import 'package:minigames/features/RunGame/NotCollisionPage.dart';
import 'features/BeforeLogin/BeforeLoginPage.dart';
import 'core/colors.dart'; // 색상 파일 임포트
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart'; // 카카오 SDK 임포트
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/RunGame/RunGamePage.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AudioPlayer _audioPlayer = AudioPlayer();  // 오디오플레이어 인스턴스 생성

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic(); // 앱 시작 시 배경음악 재생
  }

  void _playBackgroundMusic() async {
    await _audioPlayer.setSource(AssetSource('audios/Background.mp3'));
    _audioPlayer.setReleaseMode(ReleaseMode.loop);  // 반복 재생
    _audioPlayer.play(AssetSource('audios/Background.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
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

      // 첫 화면 설정
      home: NotCollisionPage(),
    );
  }
}
