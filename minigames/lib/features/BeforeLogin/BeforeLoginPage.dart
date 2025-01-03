import 'package:flutter/material.dart';
import 'widgets/background_image.dart';
import 'widgets/login_button.dart';

class BeforeLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 120), // 120만큼의 여백

              const Text(
                '공대생\n터치',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20), // 20만큼의 여백

              // 로그인 버튼
              LoginButton(),
            ],
          ),
        ],
      )
    );
  }
}