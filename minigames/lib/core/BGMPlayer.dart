import 'package:audioplayers/audioplayers.dart';

class BGMPlayer {
  static final BGMPlayer _instance = BGMPlayer._internal();
  factory BGMPlayer() => _instance;

  final AudioPlayer _audioPlayer = AudioPlayer();

  BGMPlayer._internal(); // ✅ 싱글톤 패턴 생성자

  Future<void> playBGM(String assetPath) async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // ✅ 무한 반복 설정
      await _audioPlayer.setSource(AssetSource(assetPath)); // ✅ 사운드 소스 설정 추가
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print("오류 발생: $e");
    }
  }

  Future<void> stopBGM() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
