import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:minigames/features/GameOver/widgets/buttons.dart';
import 'package:minigames/features/GameOver/widgets/score.dart';
import '../../core/ScoreManager.dart';
import '../Home/widgets/background_image.dart';
import '../../core/colors.dart';

final ScoreManager scoreManager = ScoreManager();

class GameOverPage extends StatelessWidget {
  final ScoreManager scoreManager;

  const GameOverPage({super.key, required this.scoreManager});

  Future<void> shareScoreWithKakao(BuildContext context) async {
    try {
      final score = scoreManager.score; // 현재 점수 가져오기

      // 카카오 메시지 생성
      final TextTemplate defaultTex = TextTemplate(
        text: '내 점수는 $score점! 최고 점수에 도전해보세요!',
        link: Link(
          webUrl: Uri.parse('https://kakao.com'), // 필수지만 실제 사용 안 함
          mobileWebUrl: Uri.parse('https://kakao.com'),
        ),
      );

      // 카카오 링크 메시지 전송
      if (await ShareClient.instance.isKakaoTalkSharingAvailable()) {
        print('카카오톡 앱 실행 요청 시작');
        Uri uri = await ShareClient.instance.shareDefault(template: defaultTex);
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 앱 실행 요청 완료');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카카오톡으로 점수 공유 성공!')),
        );
      } else {
        throw Exception('카카오톡 공유를 사용할 수 없습니다.');
      }
    } catch (error) {
      print('카카오 메시지 공유 오류: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카카오 메시지 공유 오류: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Score(scoreManager: scoreManager),
                  const SizedBox(height: 30),

                  // ✅ HOME & RETRY 버튼을 가로로 나란히 배치
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      Buttons(scoreManager: scoreManager),
                    ],
                  ),

                  const SizedBox(height: 30), // 버튼들 아래 간격 추가
                  // ✅ SHARE 버튼
                  DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // ✅ 그림자 설정
                          offset: const Offset(0, 4),
                          spreadRadius: 2,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () => shareScoreWithKakao(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.customYellow, // 버튼 색상
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0, // 기본 Elevation 제거
                      ),
                      child: const Text(
                        'SHARE',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // 글씨 색상
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
