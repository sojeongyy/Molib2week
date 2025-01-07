import 'dart:math';

import 'package:flutter/material.dart';
import '../../core/colors.dart';
import 'widgets/background_image.dart';
import 'widgets/login_button.dart';

class BeforeLoginPage extends StatefulWidget {
  @override
  _BeforeLoginPageState createState() => _BeforeLoginPageState();
}

class _BeforeLoginPageState extends State<BeforeLoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation; // ✅ 애니메이션 값 정의
  late Animation<double> _textAnimation;   // ✅ 텍스트 이동 애니메이션


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // 애니메이션 속도
    )..forward(); // ✅ 애니메이션 자동 실행

    // ✅ 타이틀 애니메이션 (완료 후 텍스트 시작)
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7, curve: Curves.easeInOut)),
    );

    // ✅ 텍스트 애니메이션 (title 완전히 나타난 후 등장)
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ 메모리 누수 방지
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.almostWhite,
      body: Stack(
        children: [
          //BackgroundImage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //const SizedBox(height: 50), // 120만큼의 여백

              // ✅ 애니메이션 추가
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.white, Colors.white.withOpacity(0)],
                        stops: [_animation.value, _animation.value], // ✅ 애니메이션에 따라 점진적으로 나타남
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn, // ✅ 투명도 조절
                    child: Image.asset('assets/images/title.png', width: 300),
                  );
                },
              ),
              const SizedBox(height: 30), // 20만큼의 여백
              // Text(
              //   'GONGDAE VERSION', // ✅ 추가된 부제목
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 24, // ✅ 작은 크기
              //     fontWeight: FontWeight.w500, // ✅ 중간 두께
              //     color: Colors.black87,
              //     fontFamily: 'cooper-bold-bt',
              //   ),
              // ),
              // ✅ GONGDAE VERSION 텍스트가 서서히 밑에서 등장 (Gradient로 조절)
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.white, Colors.white.withOpacity(0)],
                        stops: [_textAnimation.value, _textAnimation.value],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: const Text(
                      'GONGDAE VERSION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontFamily: 'cooper-bold-bt',
                      ),
                    ),
                  );
                },
              ),
              // 로그인 버튼 가운데 정렬
              const SizedBox(height: 60),

              Center(
                child: LoginButton(),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 40,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi), // ✅ pi는 180도 회전을 의미 (좌우반전)
              child: Image.asset(
                'assets/images/green_person.png',
                width: 130,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: Image.asset('assets/images/yellow_person.png', width: 130),
          ),
        ],
      )
    );
  }
}