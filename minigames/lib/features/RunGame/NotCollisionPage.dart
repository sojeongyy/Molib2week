import 'package:flutter/material.dart';
import '../../core/NextButton.dart';
import 'widgets/background_image.dart';
import '../../core/colors.dart';

class NotCollisionPage extends StatefulWidget {
  final int level;
  const NotCollisionPage({super.key, required this.level});

  @override
  _NotCollisionPageState createState() => _NotCollisionPageState();
}

class _NotCollisionPageState extends State<NotCollisionPage> with SingleTickerProviderStateMixin {
  double blueCharacterY = 400; // Initial Y position for the blue character
  double blueCharacterX = 200; // Initial X position for the blue character
  late AnimationController _animationController;
  late Future<void> _delayedTransition;

  @override
  void initState() {

    super.initState(); // ✅ 상태 초기화

    // Initialize the character to start from the center of the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      blueCharacterX = MediaQuery.of(context).size.width / 2 - 85; // Center X position
      blueCharacterY = MediaQuery.of(context).size.height / 2 - 85; // Center Y position
      setState(() {});
    });

    // Animation controller to move the blue character downward
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(() {
      setState(() {
        blueCharacterY = 400 + _animationController.value * 300;
      });
    });

    // Start the downward movement immediately
    _animationController.repeat(reverse: false);

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          // Professor image
          Positioned(
            top: 200,
            right: 50,
            child: Image.asset(
              'assets/images/professor.png',
              width: 170,
            ),
          ),

          // Blue character moving downward animation
          AnimatedPositioned(
            duration: Duration(milliseconds: 0),
            top: blueCharacterY,
            left: blueCharacterX,
            child: Image.asset(
              'assets/images/blue_person.png',
              width: 170,
            ),
          ),
          const SizedBox(height: 90), // 20만큼의 여백

          // 로그인 버튼 가운데 정렬
          Center(
            child: NextButton(level: widget.level),
          ),
        ],
      ),
    );
  }
}
