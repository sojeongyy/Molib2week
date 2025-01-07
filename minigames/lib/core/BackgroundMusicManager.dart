import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicPage {
  static final AudioPlayer _audioPlayer = AudioPlayer(); // ✅ 전역 인스턴스
  static bool _isPlaying = false; // ✅ 재생 여부

  // ✅ 배경음악 재생 (어디서든 호출 가능)
  static Future<void> play({String? assetPath}) async {
    await stop(); // ✅ 기존 음악 중지 후 재생
    if (assetPath != null) {
      await _audioPlayer.setSource(AssetSource(assetPath));
    } else {
      await _audioPlayer.setSource(AssetSource('audios/Background.mp3'));
    }
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.resume();
    _isPlaying = true;
  }

  // ✅ 배경음악 정지 (어디서든 호출 가능)
  static Future<void> stop() async {
    await _audioPlayer.stop();
  }

  // ✅ 오디오 플레이어 해제
  static void dispose() {
    _audioPlayer.dispose();
  }
}
