import 'package:flutter/material.dart';

class RunState extends ChangeNotifier {
  int score;
  int lives;
  static const int _maxLifes = 3;
  RunState({this.score = 0, this.lives = _maxLifes});

  void removeLife() {
    if (lives > 0) {
      lives--;
      notifyListeners();
    }
  }

  void addLife() {
    if (lives < _maxLifes) {
      lives++;
      notifyListeners();
    }
  }

  void addScore(int value) {
    score += value;
    notifyListeners();
  }
}
