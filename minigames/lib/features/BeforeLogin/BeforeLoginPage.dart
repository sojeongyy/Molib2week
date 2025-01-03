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

              const Center(  // 텍스트도 가운데 정렬
                child: Text(
                  'DUMB WAYS\nto be 공머생',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 90), // 20만큼의 여백

              // 로그인 버튼 가운데 정렬
              Center(
                child: LoginButton(),
              ),
            ],
          ),
        ],
      )
    );
  }
}