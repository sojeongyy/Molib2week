import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CorrectPage extends StatefulWidget {
  final String correctCharacter; // ✅ 정답 캐릭터를 받아오기 위한 매개변수

  const CorrectPage({super.key, required this.correctCharacter});

  @override
  State<CorrectPage> createState() => _CorrectPageState();
}

class _CorrectPageState extends State<CorrectPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE1FB),
      body: Stack(
        children: [
          // ✅ 중앙에 여자 캐릭터와 정답 캐릭터 배치
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ 두근거리는 하트 애니메이션 적용
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: SvgPicture.asset('assets/vectors/heart.svg', width: 130),
                ),

                const SizedBox(height: 10),

                // ✅ 여자 캐릭터 (좌우 반전) + 정답 캐릭터 (동적으로 표시)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 좌우 반전된 여자 캐릭터
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.14159),
                      child: Image.asset('assets/images/pink_person.png', width: 150),
                    ),
                    const SizedBox(width: 20),
                    // ✅ 정답 캐릭터를 전달받아 표시
                    Image.asset(widget.correctCharacter, width: 150),
                  ],
                ),


                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // 이전 화면으로 돌아가기
                  },
                  child: const Text('다시 도전하기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
