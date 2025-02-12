import 'package:flutter/material.dart';

class RunState extends ChangeNotifier {
  int score;
  int lives;

  RunState({this.score = 0, this.lives = 3});

  void removeLife() {
    if (lives > 0) {
      lives--;
      notifyListeners();
    }
  }

  void addScore(int value) {
    score += value;
    notifyListeners();
  }
}
