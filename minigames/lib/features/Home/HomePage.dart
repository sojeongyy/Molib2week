import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/scoreboard.dart';
import '../Login/widgets/background_image.dart';
import '../../core/colors.dart';

class HomePage extends StatelessWidget {
  final String nickname;

  const HomePage({Key? key, required this.nickname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 팝업 메시지를 build 이후에 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$nickname님, 반갑습니다!'),
          duration: const Duration(seconds: 3), // 3초 동안 표시
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16), // 화면 가장자리와의 간격
        ),
      );
    });

    return Scaffold(
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
                      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15), // 버튼 내부 여백
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      'PLAY',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10, // 화면 하단에서 20px 위에 위치
            left: 30,
            child: Image.asset(
              'assets/images/brown_person.png',
              width: 150, // 이미지 크기
            ),
          ),
          Positioned(
            bottom: 20, // 화면 하단에서 20px 위에 위치
            right: 30,
            child: Image.asset(
              'assets/images/yellow_person.png',
              width: 150, // 이미지 크기
            ),
          ),

          // ✅ 오른쪽 상단 벡터 이미지 추가
          Positioned(
            top: 20, // 화면 상단에서 20px 아래
            right: 70, // 오른쪽에서 70px 떨어진 위치
            child: SvgPicture.asset(
              'assets/vectors/user.svg', // 첫 번째 벡터 이미지
              width: 40,
            ),
          ),
          Positioned(
            top: 20,
            right: 20, // 오른쪽에서 20px 떨어진 위치
            child: SvgPicture.asset(
              'assets/vectors/setting.svg', // 두 번째 벡터 이미지
              width: 40,
            ),
          ),
        ],
      ),
    );
  }
}
