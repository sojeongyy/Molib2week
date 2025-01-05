import 'package:assets_audio_player/assets_audio_player.dart';

class BackgroundMusicManager {
  static final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();

  /// ✅ 배경 음악 초기화 및 재생
  static void startBackgroundMusic() {
    _assetsAudioPlayer.open(
      Audio("assets/audios/music.mp3"),
      loopMode: LoopMode.single, // 반복 재생
      autoStart: true,           // 자동 시작
      showNotification: false,   // 알림 표시 안 함
    );
  }

  /// ✅ 음악 재생
  static void playMusic() {
    _assetsAudioPlayer.play();
  }

  /// ✅ 음악 일시 정지
  static void pauseMusic() {
    _assetsAudioPlayer.pause();
  }

  /// ✅ 음악 정지
  static void stopMusic() {
    _assetsAudioPlayer.stop();
  }
}
