import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/colors.dart';
import '../../Login/LoginPage.dart'; // 로그인 페이지 import

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    // SharedPreferences 초기화
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 모든 데이터 삭제

    // 로그인 페이지로 이동
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, // 이전 라우트를 모두 제거
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.customPink,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // ✅ 그림자 색상
            offset: const Offset(0, 3),           // ✅ 그림자 위치
            spreadRadius: 2,                     // ✅ 퍼짐 정도
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _logout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // ✅ 색상 투명 (DecoratedBox로 설정)
          elevation: 0, // ✅ 버튼 자체의 기본 그림자 제거
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'LOGOUT',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
