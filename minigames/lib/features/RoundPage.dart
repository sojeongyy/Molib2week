import 'package:flutter/material.dart';

import 'BeforeLogin/widgets/background_image.dart';

class RoundPage extends StatelessWidget {
  final int roundNumber;
  final VoidCallback onRoundComplete; // ✅ 라운드 완료 후 콜백

  const RoundPage({super.key, required this.roundNumber, required this.onRoundComplete});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) { // ✅ context.mounted 추가
          onRoundComplete();
        }
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          // ✅ BackgroundImage를 배경으로 지정
          BackgroundImage(),
          // ✅ 중앙에 Round 텍스트 추가
          Center(
            child: Text(
              'Round $roundNumber',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
