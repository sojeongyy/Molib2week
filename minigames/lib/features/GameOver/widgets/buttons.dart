import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../../../core/ScoreManager.dart';
import '../../../core/colors.dart';
import '../../Home/HomePage.dart';

class Buttons extends StatelessWidget {
  final ScoreManager scoreManager;

  const Buttons({super.key, required this.scoreManager});
  //
  // Future<void> shareScoreWithKakao(BuildContext context) async {
  //   try {
  //     final score = scoreManager.score; // 현재 점수 가져오기
  //
  //     // 카카오 메시지 생성
  //     final template = TextTemplate(
  //       text: '내 점수는 $score점! 최고 점수에 도전해보세요!',
  //       link: Link(
  //         webUrl: Uri.parse('https://kakao.com'), // 필수지만 실제 사용 안 함
  //         mobileWebUrl: Uri.parse('https://kakao.com'),
  //       ),
  //     );
  //
  //     // 카카오 링크 메시지 전송
  //     if (await ShareClient.instance.isKakaoTalkSharingAvailable()) {
  //       await ShareClient.instance.shareDefault(template: template);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('카카오톡으로 점수 공유 성공!')),
  //       );
  //     } else {
  //       throw Exception('카카오톡 공유를 사용할 수 없습니다.');
  //     }
  //   } catch (error) {
  //     print('카카오 메시지 공유 오류: $error');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('카카오 메시지 공유 오류: $error')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // ✅ 버튼을 가운데 정렬
      children: [
        // ✅ HOME 버튼
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
            onPressed: () {
              scoreManager.resetScore();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.customBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0, // ✅ 기본 Elevation 제거
            ),
            child: const Text(
              'HOME',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20), // ✅ 버튼 간 간격 추가

        // ✅ RETRY 버튼
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
            onPressed: () {
              scoreManager.resetScore();
              startRandomGame(context, 1, 1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.customBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0, // ✅ 기본 Elevation 제거
            ),
            child: const Text(
              'RETRY',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

      ],
    );
  }
}
