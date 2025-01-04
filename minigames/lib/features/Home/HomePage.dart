import 'package:flutter/material.dart';
import 'widgets/scoreboard.dart';
import '../Login/widgets/background_image.dart';
import '../../core/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: Scaffold(
        body: Stack( // Stack으로 배경과 위젯을 겹쳐서 표시
          children: [
            const BackgroundImage(), // 배경 이미지를 고정으로 사용
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 수직 중앙 정렬
                  crossAxisAlignment: CrossAxisAlignment.center, // 수평 중앙 정렬
                  children: [
                    // Scoreboard 위젯
                    Scoreboard(scores: [720, 700, 600]),
                    const SizedBox(height: 30), // 여백 추가

                    // Play 버튼
                    ElevatedButton(
                      onPressed: () {
                        print('Play Button Pressed');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.softBlue, // 버튼 색상
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), // 버튼 내부 여백
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        'PLAY',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.almostWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
