import 'package:flutter/material.dart';
import 'package:minigames/core/BackgroundMusicManager.dart';
import 'package:minigames/features/CoupleGame/CoupleGamePage.dart';
import 'package:audioplayers/audioplayers.dart';  // 오디오플레이어 임포트
import 'package:minigames/features/RunGame/NotCollisionPage.dart';
import 'features/BeforeLogin/BeforeLoginPage.dart';
import 'core/colors.dart'; // 색상 파일 임포트
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart'; // 카카오 SDK 임포트
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/BGMPlayer.dart'; // 배경음악 플레이어 임포트


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 초기화
  BackgroundMusicPage.play(); // 배경음악 재생
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
    //BackgroundMusicPage._playBackgroundMusic(); // 앱 시작 시 배경음악 재생
    BackgroundMusicPage.play();
  }

  // void _playBackgroundMusic() async {
  //   await _audioPlayer.setSource(AssetSource('audios/Background.mp3'));
  //   _audioPlayer.setReleaseMode(ReleaseMode.loop);  // 반복 재생
  //   _audioPlayer.play(AssetSource('audios/Background.mp3'));
  // }
  //
  // @override
  // void dispose() {
  //   _audioPlayer.dispose(); // 메모리 해제
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      title: '공대생 터치!',

      // 앱 전체 테마 설정 (app_colors.dart 활용)
      theme: ThemeData(
        primaryColor: AppColors.customBlue,  // 기본 색상 설정
        scaffoldBackgroundColor: AppColors.almostWhite,  // 배경색
        fontFamily: 'cooper-bold-bt', // 기본 폰트 설정
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),

        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: AppColors.customBlue),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            overlayColor: Colors.transparent,
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.customBlue,
          selectionColor: AppColors.customBlue,
          selectionHandleColor: AppColors.customBlue,
        ),
      ),

      // 첫 화면 설정
      home: BeforeLoginPage(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'core/BGMPlayer.dart';
// import 'core/colors.dart';
// import 'features/BeforeLogin/BeforeLoginPage.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     BGMPlayer().playBGM('audios/Background.mp3'); // ✅ 전역 BGM 자동 재생
//   }
//
//   @override
//   void dispose() {
//     BGMPlayer().stopBGM(); // ✅ 앱 종료 시 BGM 정지
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // 디버그 배너 제거
//       title: '공대생 터치!',
//
//       // 앱 전체 테마 설정 (app_colors.dart 활용)
//       theme: ThemeData(
//         primaryColor: AppColors.customBlue,  // 기본 색상 설정
//         scaffoldBackgroundColor: AppColors.almostWhite,  // 배경색
//         fontFamily: 'cooper-bold-bt', // 기본 폰트 설정
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.black),
//         ),
//
//         inputDecorationTheme: InputDecorationTheme(
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(width: 2, color: AppColors.customBlue),
//           ),
//         ),
//
//         textButtonTheme: TextButtonThemeData(
//           style: TextButton.styleFrom(
//             foregroundColor: Colors.black,
//             overlayColor: Colors.transparent,
//           ),
//         ),
//       ),
//
//       // 첫 화면 설정
//       home: BeforeLoginPage(),
//     );
//   }
// }
