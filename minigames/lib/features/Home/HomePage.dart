import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minigames/core/BackgroundMusicManager.dart';
import 'package:minigames/features/Home/widgets/profile_popup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minigames/features/Home/widgets/play_button.dart';
import '../../core/ScoreManager.dart';
import '../BugGame/BugGamePage.dart';
import '../UhWordGame/UhGamePage.dart';
import 'widgets/scoreboard.dart';
import '../GameOver/widgets/score.dart';
import '../../core/ScoreManager.dart';
import 'widgets/background_image.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'widgets/profilePopup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../RunGame/RunGamePage.dart';
import '../CoupleGame/CoupleGamePage.dart';

final ScoreManager scoreManager = ScoreManager();

// ✅ 게임을 성공 후 RoundPage를 거쳐 랜덤 게임 시작 (mounted 체크 추가)
void startRandomGame(BuildContext context, int roundNumber, int level) {
  final randomIndex = Random().nextInt(4); // ✅ 3개의 게임을 랜덤으로 선택 (0, 1, 2)

  // ✅ 기존 페이지를 닫고 랜덤으로 새로운 게임 시작
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        switch (randomIndex) {
          case 0:
            return CoupleGamePage(level: level, scoreManager: scoreManager);
          case 1:
            return RunGamePage(level: level, scoreManager: scoreManager);
          case 2:
            return BugGamePage(level: level, scoreManager: scoreManager);
          case 3:
            return UhGamePage(level: level, scoreManager: scoreManager);
          default:
            return BugGamePage(level: level, scoreManager: scoreManager);
        }
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  String nickname = '';
  bool isKakaoLinked = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  //final AudioPlayer _pageAudioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // ✅ 비행기 애니메이션 컨트롤러 설정
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // 5초 동안 이동
      vsync: this,
    )..repeat(); // 반복 실행

    // ✅ 오른쪽에서 왼쪽으로 이동하는 애니메이션
    _animation = Tween<double>(
      begin: 1.0,  // 화면 오른쪽 바깥
      end: -1.0,   // 화면 왼쪽 바깥
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 컨트롤러 해제
    super.dispose();
  }


  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nickname = prefs.getString('nickname') ?? '사용자';
      isKakaoLinked = prefs.getBool('isKakaoLinked') ?? false;
    });
  }

  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유저 정보를 찾을 수 없습니다.')),
      );
      throw Exception('유저 ID가 없습니다.');
    }
    return userId;
  }

  Future<void> _linkKakao(BuildContext context) async {
    try {
      final userId = await _getUserId();

      // 카카오 로그인
      final installed = await isKakaoTalkInstalled();
      final authCode = installed
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      // 카카오 사용자 정보 가져오기
      final user = await UserApi.instance.me();
      final kakaoId = user.id.toString();
      final profileImageUrl = user.kakaoAccount?.profile?.profileImageUrl;

      // 서버로 카카오 연동 요청
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
      final response = await http.post(
        Uri.parse('$apiUrl/auth/kakao/link'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'kakaoId': kakaoId,
          'profileImageUrl': profileImageUrl,
        }),
      );

      final loginData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          isKakaoLinked = true;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카카오 연동이 완료되었습니다.')),
        );

        // SharedPreferences 업데이트
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isKakaoLinked', loginData['user']['isKakaoLinked'] ?? false);
        prefs.setString('profileImageUrl', loginData['user']['profile_image_url']);
      } else {
        final error = json.decode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('연동 실패: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카카오 연동 오류: $e')),
      );
    }
  }

  Future<void> _unlinkKakao(BuildContext context) async {
    try {
      final userId = await _getUserId();
      final requestbody = json.encode({'userId': userId,});
      print('요청 본문: $requestbody');

      // 서버로 카카오 연결 해제 요청
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
      print('요청 URL: $apiUrl/auth/kakao/unlink');
      final response = await http.post(
        Uri.parse('$apiUrl/auth/kakao/unlink'),
        headers: {'Content-Type': 'application/json'},
        body: requestbody,
      );
      print('응답 상태 코드: ${response.statusCode}');
      print('응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          isKakaoLinked = false;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카카오 연결이 해제되었습니다.')),
        );

        // SharedPreferences 업데이트
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isKakaoLinked', false);
        prefs.setString('profileImageUrl', '');
      } else {
        final error = json.decode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('연결 해제 실패: $error')),
        );
      }
    } catch (e) {
      print('카카오 연결 해제 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카카오 연결 해제 오류: $e')),
      );
    }
  }

  void _showProfilePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProfilePopupPage(
          nickname: nickname,
          isKakaoLinked: isKakaoLinked,
          onKakaoLink: () => _linkKakao(context),
          onKakaoUnlink: () => _unlinkKakao(context),
        );
      },
    );
  }

// class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Scoreboard(),
                  const SizedBox(height: 50),
                  PlayButton(
                    onPressed: () {
                      startRandomGame(context, 1, 1);
                      BackgroundMusicPage.stop();
                    },
                    scoreManager: scoreManager, // ✅ 점수 매니저 전달
                  ),
                ],
              ),
            ),
          ),
          // ✅ 비행기 애니메이션 추가
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: 110, // ✅ 스코어보드 바로 위쪽
                left: MediaQuery.of(context).size.width * _animation.value, // 오른쪽에서 왼쪽으로
                child: Image.asset(
                  'assets/images/plane.png',
                  width: 300,
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 70,
            child: GestureDetector(
              onTap: () => _showProfilePopup(context), // 프로필 팝업 표시
              child: SvgPicture.asset(
                'assets/vectors/user.svg',
                width: 40,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: SvgPicture.asset(
              'assets/vectors/setting.svg',
              width: 40,
            ),
          ),
        ],
      ),
    );
  }
}
