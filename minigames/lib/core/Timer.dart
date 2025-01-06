import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:minigames/features/RunGame/CollisionPage.dart';
import '../../core/colors.dart';

class TimerManager {
  Timer? _successTimer;
  double timeLeft;
  bool isGameOver = false;
  bool _isDisposed = false;  // ✅ dispose 상태 관리 추가
  final int duration;
  final AnimationController controller;
  final BuildContext context;
  final Function onComplete;
  final Function(double) onUpdate; // 상태 업데이트 콜백 추가

  TimerManager({
    required this.context,
    required this.duration,
    required this.controller,
    required this.onComplete,
    required this.onUpdate,
  }) : timeLeft = duration.toDouble();

  void startTimer() {
    if (_isDisposed) return; // ✅ dispose 상태 체크 추가

    timeLeft = duration.toDouble();
    _successTimer?.cancel(); // 기존 타이머 제거
    _successTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      if (timeLeft > 0) {
        timeLeft -= 0.1;
        onUpdate(timeLeft); // ✅ 안전한 UI 업데이트
      } else {
        if (!isGameOver) {
          isGameOver = true;
          controller.stop();
          onComplete();
        }
        timer.cancel();
      }
    });
  }

  void cancelTimer() {
    _successTimer?.cancel();
    if (!_isDisposed) controller.stop(); // ✅ dispose 상태 체크 후 stop
  }

  void dispose() {
    _successTimer?.cancel();
    if (!_isDisposed) controller.dispose(); // ✅ dispose 상태 체크 후 dispose
    _isDisposed = true;
  }
}

Widget buildProgressBar(double timeLeft, int gameDuration) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 100),
    width: max(1, MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width * (1 - (timeLeft / gameDuration))),
    height: 5,
    decoration: BoxDecoration(
      color: AppColors.customMint,
    ),
  );
}
