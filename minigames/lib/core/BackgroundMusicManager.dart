import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicPage extends StatefulWidget {
  const BackgroundMusicPage({super.key});

  @override
  State<BackgroundMusicPage> createState() => _BackgroundMusicPageState();
}

class _BackgroundMusicPageState extends State<BackgroundMusicPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();  // 앱 실행 시 배경음악 재생
  }

  // 배경음악 반복 재생
  void _playBackgroundMusic() async {
    await _audioPlayer.setSource(AssetSource('../../assets/audios/Background.mp3'));
    _audioPlayer.setReleaseMode(ReleaseMode.loop);  // 반복 재생 모드 설정
    _audioPlayer.play(AssetSource('../../assets/audios/Background.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();  // 앱 종료 시 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: Text(
  //         '배경음악이 반복 재생 중입니다!',
  //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //       ),
  //     ),
  //   );
  // }
}
