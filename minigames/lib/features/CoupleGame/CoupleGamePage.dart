import 'package:flutter/material.dart';

import 'CorrectPage.dart';
import 'InCorrectPage.dart';
import '../../core/navigation_helper.dart';

class CoupleGamePage extends StatefulWidget {
  const CoupleGamePage({super.key});

  @override
  State<CoupleGamePage> createState() => _CoupleGamePageState();
}

class _CoupleGamePageState extends State<CoupleGamePage> {
  // 현재 말풍선과 정답 캐릭터
  String speechBubbleImage = 'assets/images/green_think.png';
  bool isCorrect = false;

  // 정답 캐릭터 결정 (말풍선에 따라)
  String getTargetCharacter() {
    if (speechBubbleImage == 'assets/images/green_think.png') {
      return 'assets/images/green_person.png';
    } else if (speechBubbleImage == 'assets/images/yellow_think.png') {
      return 'assets/images/yellow_person.png';
    } else if (speechBubbleImage == 'assets/images/brown_think.png') {
      return 'assets/images/brown_person.png';
    } else {
      return 'assets/images/blue_person.png';
    }
  }


  @override
  Widget build(BuildContext context) {
    String targetCharacter = getTargetCharacter(); // 정답 캐릭터 업데이트

    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: Scaffold(
        backgroundColor: const Color(0xFFFFE1FB), // 배경색
        body: Stack(
          children: [
            // ✅ 중앙 캐릭터와 말풍선 (정답에 따른 말풍선 변경)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 말풍선 이미지 (정답에 따라 변경)
                  // Image.asset(speechBubbleImage, width: 120),
                  const SizedBox(height: 10),

                  // 중앙 캐릭터 (DragTarget)
                  DragTarget<String>(
                    onAccept: (data) {
                      if (data == targetCharacter) {
                        navigateWithFade(context, CorrectPage(correctCharacter: targetCharacter));
                      } else {
                        navigateWithFade(context, const InCorrectPage());
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Column(
                        children: [
                          Image.asset('assets/images/pink_person.png', width: 150),
                          const SizedBox(height: 10),
                          // isCorrect
                          //     ? const Text("정답!", style: TextStyle(fontSize: 30, color: Colors.green))
                          //     : const Text("캐릭터를 가져와 보세요!", style: TextStyle(fontSize: 20)),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // ✅ 말풍선 (중앙 캐릭터보다 살짝 위 오른쪽에 위치)
            Positioned(
              top: 200,
              right: 40,
              child: Image.asset(
                speechBubbleImage,
                width: 120,
              ),
            ),

            // ✅ 상단 캐릭터 (오답)
            Positioned(
              top: 100,
              left: 50,
              child: Draggable<String>(
                data: 'assets/images/blue_person.png',
                feedback: Image.asset('assets/images/blue_person.png', width: 100),
                child: Image.asset('assets/images/blue_person.png', width: 100),
              ),
            ),

            // ✅ 우측 캐릭터 (오답)
            Positioned(
              top: 100,
              right: 40,
              child: Draggable<String>(
                data: 'assets/images/yellow_person.png',
                feedback: Image.asset('assets/images/yellow_person.png', width: 100),
                child: Image.asset('assets/images/yellow_person.png', width: 100),
              ),
            ),

            // ✅ 하단 캐릭터 (정답일 수도 있음)
            Positioned(
              bottom: 40,
              left: 40,
              child: Draggable<String>(
                data: 'assets/images/green_person.png',
                feedback: Image.asset('assets/images/green_person.png', width: 100),
                child: Image.asset('assets/images/green_person.png', width: 100),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Draggable<String>(
                data: 'assets/images/brown_person.png',
                feedback: Image.asset('assets/images/brown_person.png', width: 100),
                child: Image.asset('assets/images/brown_person.png', width: 100),
              ),
            ),

            // ✅ 새로운 말풍선으로 문제 변경 버튼
            Positioned(
              top: 0,
              right: 10,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // 랜덤하게 말풍선 변경
                    final speechBubbles = [
                      'assets/images/blue_think.png',
                      'assets/images/brown_think.png',
                      'assets/images/green_think.png',
                      'assets/images/yellow_think.png',
                    ];
                    speechBubbleImage = (speechBubbles..shuffle()).first;
                    isCorrect = false; // 정답 상태 초기화
                  });
                },
                child: const Text("새로운 문제", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
