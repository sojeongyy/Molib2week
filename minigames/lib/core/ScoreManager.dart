

class ScoreManager {
  int _score = 0;

  int get score => _score;

  void addPoints(int points) {
    _score += points;
  }

  void resetScore() {
    _score = 0;
  }
}
