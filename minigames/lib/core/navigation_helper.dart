// lib/navigation_helper.dart
import 'package:flutter/material.dart';

/// ✅ 페이지 전환 애니메이션 (재사용 가능)
void navigateWithFade(BuildContext context, Widget nextPage) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => nextPage),
  );
}

/// ✅ 페이지 전환 (현재 페이지 제거하고 새로운 페이지로 이동)
void navigateWithReplacement(BuildContext context, Widget nextPage) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => nextPage),
  );
}

/// ✅ 페이지 전환 (페이드 애니메이션 적용)
void navigateWithFadeAnimation(BuildContext context, Widget nextPage) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}
